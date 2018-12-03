python
import sys
from os.path import expanduser
sys.path.insert(1, expanduser('~/.gdb/Boost-Pretty-Printer'))
import boost
boost.register_printers()
end
