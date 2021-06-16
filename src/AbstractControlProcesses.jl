module AbstractControlProcesses

export AbstractProcess, PhysicalProcess, SimulatedProcess
export  num_outputs,
        num_inputs,
        outputrange,
        inputrange,
        isstable,
        isasstable,
        sampletime,
        periodic_wait,
        bias,
        control,
        measure,
        initialize,
        finalize

# Interface specification ===================================================================
"""
    AbstractProcess

Base abstract type for all lab processes. This should not be inherited from directly, see [`PhysicalProcess`](@ref), [`SimulatedProcess`](@ref)
"""
abstract type AbstractProcess end

"""
    PhysicalProcess <: AbstractProcess

Pysical processes should inherit from this abstract type.
"""
abstract type PhysicalProcess  <: AbstractProcess end

"""
    SimulatedProcess <: AbstractProcess

Simulated processes should inherit from this abstract type.
"""
abstract type SimulatedProcess <: AbstractProcess end

## Function definitions =====================================================================
"""
    ny = num_outputs(P::AbstractProcess)

Return the number of outputs (measurement signals) of the process.
"""
num_outputs(p::AbstractProcess) = error("Function not implemented for $(typeof(p))")

"""
    nu = num_inputs(P::AbstractProcess)

Return the number of inputs (control signals) of the process.
"""
num_inputs(p::AbstractProcess) = error("Function not implemented for $(typeof(p))")

"""
    range = outputrange(P::AbstractProcess)

Return the range of outputs (measurement signals) of the process. `range` is a vector of
tuples,  `length(range) = num_outputs(P), eltype(range) = Tuple(Real, Real)`
"""
outputrange(p::AbstractProcess) = error("Function not implemented for $(typeof(p))")

"""
    range = inputrange(P::AbstractProcess)

Return the range of inputs (control signals) of the process. `range` is a vector of
tuples, `length(range) = num_inputs(P), eltype(range) = Tuple(Real, Real)`
"""
inputrange(p::AbstractProcess) = error("Function not implemented for $(typeof(p))")

"""
    isstable(P::AbstractProcess)

Return true/false indicating whether or not the process is stable
"""
isstable(p::AbstractProcess) = error("Function not implemented for $(typeof(p))")

"""
    isasstable(P::AbstractProcess)

Return true/false indicating whether or not the process is asymptotically stable
"""
isasstable(p::AbstractProcess) = error("Function not implemented for $(typeof(p))")

"""
    h = sampletime(P::AbstractProcess)

Return the sample time of the process in seconds.
"""
sampletime(p::AbstractProcess) = error("Function not implemented for $(typeof(p))")

"""
    last_time = periodic_wait(P::AbstractProcess, last_time, dt)

Should continue execution at start of next period, i.e. when `dt` seconds has passed since `last_time`. 

For a `PhysicalProcess` this has a default implementation which sleeps until `last_time + dt` using 
`Libc.systemsleep`. Though this is more precise than using the standard `sleep` in Julia, it also 
blocks the entire Julia thread it is running on which could affect execution in some cases.

For a `SimulatedProcess` it can either be running in realtime in a background process, in which case 
it should be implemented similarly to the physical process, or it runs at full simulation speed, in 
which case the environment should simulate a step corresponding to `dt` time when `periodic_wait` is called.

A good way to initialize `last_time` to the correct value is to call `last_time = periodic_wait(P, 0.0, 0.0)`.
"""
periodic_wait(p::AbstractProcess, last_time, dt) = error("Function not implemented for $(typeof(p))")
function periodic_wait(p::PhysicalProcess, last_time, dt) 
    target_time = last_time + dt
    Libc.systemsleep(max(0, target_time - time()))
    return time()
end

"""
    b = bias(P::AbstractProcess)

Return an input bias for the process. This could be, i.e., the constant input u₀ around which
a nonlinear system is linearized, or whatever other bias might exist on the input.
`length(b) = num_inputs(P)`
"""
bias(p::AbstractProcess) = error("Function not implemented for $(typeof(p))")

"""
    control(P::AbstractProcess, u)

Send a control signal to the process. `u` must have dimension equal to `num_inputs(P)`
"""
control(p::AbstractProcess, u) = error("Function not implemented for $(typeof(p))")

"""
    y = measure(P::AbstractProcess)

Return a measurement from the process. `y` has length `num_outputs(P)`
"""
measure(p::AbstractProcess) = error("Function not implemented for $(typeof(p))")

"""
    initialize(P::AbstractProcess)

This function is called before any control or measurement operations are performed. During a call to `initialize`, one might set up external communications etc. After control is done,
the function [`finalize`](@ref) is called.
"""
initialize(p::AbstractProcess) = error("Function not implemented for $(typeof(p))")

"""
    finalize(P::AbstractProcess)

This function is called after any control or measurement operations are performed. During a call to `finalize`, one might finalize external communications etc. Before control is done,
the function [`initialize`](@ref) is called.
"""
Base.finalize(p::AbstractProcess) = error("Function not implemented for $(typeof(p))")


end # module
