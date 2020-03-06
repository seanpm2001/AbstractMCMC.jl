struct MyModel <: AbstractMCMC.AbstractModel end

struct MyTransition
    a::Float64
    b::Float64
end

struct MySampler <: AbstractMCMC.AbstractSampler end

struct MyChain <: AbstractMCMC.AbstractChains
    as::Vector{Float64}
    bs::Vector{Float64}
end

function AbstractMCMC.step!(
    rng::AbstractRNG,
    model::MyModel,
    sampler::MySampler,
    N::Integer,
    transition::Union{Nothing,MyTransition};
    sleepy = false,
    loggers = false,
    kwargs...
)
    a = rand(rng)
    b = randn(rng)

    loggers && push!(LOGGERS, Logging.current_logger())
    sleepy && sleep(0.001)

    return MyTransition(a, b)
end

function AbstractMCMC.bundle_samples(
    rng::AbstractRNG,
    model::MyModel,
    sampler::MySampler,
    N::Integer,
    transitions::Vector{MyTransition},
    chain_type::Type{MyChain};
    kwargs...
)
    n = length(transitions)
    as = Vector{Float64}(undef, n)
    bs = Vector{Float64}(undef, n)
    for i in 1:n
        transition = transitions[i]
        as[i] = transition.a
        bs[i] = transition.b
    end

    return MyChain(as, bs)
end

AbstractMCMC.chainscat(chains::Union{MyChain,Vector{<:MyChain}}...) = vcat(chains...)