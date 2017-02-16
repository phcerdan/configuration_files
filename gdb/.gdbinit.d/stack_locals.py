class StackLocals(Dashboard.Module):
    """Based on Stack. Show the current stack trace including the function name and the file
location, if available. Force to show locals"""

    def label(self):
        return 'StackLocals'

    def lines(self, term_width, style_changed):
        frames = []
        number = 0
        selected_index = 0
        frame = gdb.newest_frame()
        while frame:
            frame_lines = []
            # fetch frame info
            selected = (frame == gdb.selected_frame())
            if selected:
                selected_index = number
            style = R.style_selected_1 if selected else R.style_selected_2
            frame_id = ansi(str(number), style)
            info = StackLocals.get_pc_line(frame, style)
            frame_lines.append('[{}] {}'.format(frame_id, info))
            # fetch frame arguments and locals
            decorator = gdb.FrameDecorator.FrameDecorator(frame)
            if self.show_arguments:
                frame_args = decorator.frame_args()
                args_lines = self.fetch_frame_info(frame, frame_args, 'arg')
                if args_lines:
                    frame_lines.extend(args_lines)
                else:
                    frame_lines.append(ansi('(no arguments)', R.style_low))
            if self.show_locals:
                frame_locals = decorator.frame_locals()
                locals_lines = self.fetch_frame_info(frame, frame_locals, 'loc')
                if locals_lines:
                    frame_lines.extend(locals_lines)
                else:
                    frame_lines.append(ansi('(no locals)', R.style_low))
            # add frame
            frames.append(frame_lines)
            # next
            frame = frame.older()
            number += 1
        # format the output
        if not self.limit or self.limit >= len(frames):
            start = 0
            end = len(frames)
            more = False
        else:
            start = selected_index
            end = min(len(frames), start + self.limit)
            more = (len(frames) - start > self.limit)
        lines = []
        for frame_lines in frames[start:end]:
            lines.extend(frame_lines)
        # add the placeholder
        if more:
            lines.append('[{}]'.format(ansi('+', R.style_selected_2)))
        return lines

    def fetch_frame_info(self, frame, data, prefix):
        prefix = ansi(prefix, R.style_low)
        lines = []
        for elem in data or []:
            name = elem.sym
            value = to_string(elem.sym.value(frame))
            lines.append('{} {} = {}'.format(prefix, name, value))
        return lines

    @staticmethod
    def get_pc_line(frame, style):
        frame_pc = ansi(format_address(frame.pc()), style)
        info = 'from {}'.format(frame_pc)
        if frame.name():
            frame_name = ansi(frame.name(), style)
            try:
                # try to compute the offset relative to the current function
                value = gdb.parse_and_eval(frame.name()).address
                # it can be None even if it is part of the "stack" (C++)
                if value:
                    func_start = to_unsigned(value)
                    offset = frame.pc() - func_start
                    frame_name += '+' + ansi(str(offset), style)
            except gdb.error:
                pass  # e.g., @plt
            info += ' in {}'.format(frame_name)
            sal = frame.find_sal()
            if sal.symtab:
                file_name = ansi(sal.symtab.filename, style)
                file_line = ansi(str(sal.line), style)
                info += ' at {}:{}'.format(file_name, file_line)
        return info

    def attributes(self):
        return {
            'limit': {
                'doc': 'Maximum number of displayed frames (0 means no limit).',
                'default': 0,
                'type': int,
                'check': check_ge_zero
            },
            'arguments': {
                'doc': 'Frame arguments visibility flag.',
                'default': True,
                'name': 'show_arguments',
                'type': bool
            },
            'locals': {
                'doc': 'Frame locals visibility flag.',
                'default': True,
                'name': 'show_locals',
                'type': bool
            }
        }

