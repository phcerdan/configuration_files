#!/usr/bin
export CPUPROFILE=~/tmp/prof.out

# HEAPPROFILE=<pre> -- turns on heap profiling and dumps data using this prefix
# HEAPCHECK=<type>  -- turns on heap checking with strictness 'type'
# CPUPROFILE=<file> -- turns on cpu profiling and dumps data to this file.
# PROFILESELECTED=1 -- if set, cpu-profiler will only profile regions of code surrounded with ProfilerEnable()/ProfilerDisable()
# CPUPROFILE_FREQUENCY=x-- how many interrupts/second the cpu-profiler samples.
#
# TCMALLOC_DEBUG=<level> -- the higher level, the more messages malloc emits
# MALLOCSTATS=<level>    -- prints memory-use stats at program-exit
