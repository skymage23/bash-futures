# bash-futures

# What is "bash-futures"?
"bash-futures" is a Futures implementation for Bash shells. It is written mainly
to help in writing Bash Interactive Shell extensions, for situations where the
human operator needs to kick off a process in order to generate a needed value while
needing to be able to continue to do other work in the meantime.

It is in a very alpha state right now, and only supports Bash.


# What is a "future"?
In essence, a "future" is a promissory note.
The easiest way to think about it is to consider it to be like an "IOU" for
a value, except that there is actually a process/thread running in
the background to generate that value. With the "future" in hand,
the current process can continue and do other things until it absolutely
needs the value the "future" provides. When that happens, it "waits"
on the "future" to "come to pass" (it halts all further activity until
the "future" object indicates it now has a real value for the process to collect).
With the "future" now in fruition, and the actual value collected,
the calling process can continue.

"Futures" implementations are commonly found in multithreading and
multiprocessing libraries. I believe C# has an implementation, for
instance.

I looked around a bit, and found no implementation for this sort of behaviour
in native Bash, and I needed it to be in native Bash for another project of mine.
As such, I decided to make my own implementation.
