
```
iex(1)> c("spawn-basic.ex")
[SpawnBasic]
iex(2)> SpawnBasic.greet
Hello
:ok
iex(3)> spwan(SpawnBasic, :greet, [])
** (CompileError) iex:3: undefined function spwan/3

iex(3)> spawn(SpawnBasic, :greet, [])
Hello
#PID<0.90.0>
```
