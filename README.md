# AbstractControlProcesses
Defines an interface in Julia for interacting with simulated and physical processes.

## Interface

### Types

* `AbstractProcess`  
Base abstract type for all lab processes. This should not be inherited from directly.

* `PhysicalProcess <: AbstractProcess`  
Pysical processes should inherit from this abstract type.

* `SimulatedProcess <: AbstractProcess`  
Simulated processes should inherit from this abstract type.

### Functions

* `ny = num_outputs(P::AbstractProcess)`  
Return the number of outputs (measurement signals) of the process.

* `nu = num_inputs(P::AbstractProcess)`  
Return the number of inputs (control signals) of the process.

* `yrange = outputrange(P::AbstractProcess)`  
Return the range of outputs (measurement signals) of the process. `yrange` is a vector of
tuples,  `length(yrange) = num_outputs(P), eltype(yrange) = Tuple(Real, Real)`

* `urange = inputrange(P::AbstractProcess)`  
Return the range of inputs (control signals) of the process. `urange` is a vector of
tuples,  `length(urange) = num_inputs(P), eltype(urange) = Tuple(Real, Real)`

* `isstable(P::AbstractProcess)`  
Return true/false indicating whether or not the process is stable

* `isasstable(P::AbstractProcess)`  
Return true/false indicating whether or not the process is asymptotically stable

* `h = sampletime(P::AbstractProcess)`  
Return the sample time of the process in seconds.

* `b = bias(P::AbstractProcess)`  
Return an input bias for the process. This could be, i.e., the constant input u₀ around which a nonlinear system is linearized, or whatever other bias might exist on the input.  
`length(b) = num_inputs(P)`

* `control(P::AbstractProcess, u::AbstractVector)`  
Send a control signal to the process where `u` is an `AbstractVector` with dimension equal to `num_inputs(P)`.  
There is a default method which accepts `u` as a `Number` and forwards it as a `Vector` to the implemented version.

* `y = measure(P::AbstractProcess)`  
Return a measurement from the process where `y` has length `num_outputs(P)`

* `last_time = periodic_wait(P::AbstractProcess, last_time, dt)`  
Should continue execution at start of next period, i.e. when `dt` seconds has passed since `last_time`.   
For a `PhysicalProcess` this is has a default implementation which sleeps from `time()` until 
`last_time + dt` using `Libc.systemsleep`. Though this is more precise than using the standard 
`sleep` in Julia, it also blocks the entire Julia thread it is running on so one has to be careful 
with that sleep.  
For a `SimulatedProcess` it can either be running in realtime, in which case it should be implemented 
similarly to the physical process, or it runs at full simulation speed, in which case the environment 
should simulate a step corresponding to `dt` time when `periodic_wait` is called.

* `initialize(P::AbstractProcess)`  
This function is called before any control or measurement operations are performed. During a call to `initialize`, one might set up external communications etc. After control is done,
the function `finalize` is called.

* `finalize(P::AbstractProcess)`  
This function is called after any control or measurement operations are performed. During a call to `finalize`, one might finalize external communications etc. Before control is done,
the function `initialize` is called.

## Examples

The repo https://github.com/ControlLTH/FurutaPendulums.jl implements this interface in for both a connection to the physical proces as well as a simulated version of the physical process.
