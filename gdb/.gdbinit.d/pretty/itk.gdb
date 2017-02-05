define psp
print $arg0.m_Pointer
end

document psp
Print the object pointer from a smart pointer.
Example: psp imagePointer
end

define pspm
print $arg0.m_Pointer->$arg1
end

document pspm
print a member of the object pointed to by a smart pointer.
you can also call a member method through the smart pointer,
Example: pspm imagePtr GetSize()
end

define pspc
print *($arg0.m_Pointer)
end

document pspc
print the contents of an object pointed to with a smart pointer
Example pspc imagePtr
end
