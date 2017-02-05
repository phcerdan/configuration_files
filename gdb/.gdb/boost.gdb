python
import sys
from os.path import expanduser
sys.path.insert(0, expanduser('~/.gdb/Boost-Pretty-Printer'))
import boost.latest
boost.register_printers()
end
