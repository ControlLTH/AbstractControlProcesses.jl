# AbstractControlProcesses
Defines an interface in Julia for interacting with simulated and physical processes.

## Interface

### Types

`AbstractProcess`

Base abstract type for all lab processes. This should not be inherited from directly.

`PhysicalProcess <: AbstractProcess`

Pysical processes should inherit from this abstract type.

`SimulatedProcess <: AbstractProcess`

Simulated processes should inherit from this abstract type.

### Functions

`ny = num_outputs(P::AbstractProcess)`

Return the number of outputs (measurement signals) of the process.

`nu = num_inputs(P::AbstractProcess)`

Return the number of inputs (control signals) of the process.

`yrange = outputrange(P::AbstractProcess)`

Return the range of outputs (measurement signals) of the process. `yrange` is a vector of
tuples,  `length(yrange) = num_outputs(P), eltype(yrange) = Tuple(Real, Real)`

`urange = inputrange(P::AbstractProcess)`

Return the range of inputs (control signals) of the process. `urange` is a vector of
tuples,  `length(urange) = num_inputs(P), eltype(urange) = Tuple(Real, Real)`

`isstable(P::AbstractProcess)`

Return true/false indicating whether or not the process is stable

`isasstable(P::AbstractProcess)`

Return true/false indicating whether or not the process is asymptotically stable

`h = sampletime(P::AbstractProcess)`

Return the sample time of the process in seconds.

`b = bias(P::AbstractProcess)`

Return an input bias for the process. This could be, i.e., the constant input u₀ around which
a nonlinear system is linearized, or whatever other bias might exist on the input.
`length(b) = num_inputs(P)`

`control(P::AbstractProcess, u)`

Send a control signal to the process. `u` must have dimension equal to `num_inputs(P)`

`y = measure(P::AbstractProcess)`

Return a measurement from the process. `y` has length `num_outputs(P)`

`initialize(P::AbstractProcess)`

This function is called before any control or measurement operations are performed. During a call to `initialize`, one might set up external communications etc. After control is done,
the function `finalize` is called.

`finalize(P::AbstractProcess)`

This function is called after any control or measurement operations are performed. During a call to `finalize`, one might finalize external communications etc. Before control is done,
the function `initialize` is called.

## Examples

To be added...
