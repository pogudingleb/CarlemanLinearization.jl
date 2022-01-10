# ======================================
# Construction of the linearized system
# ======================================

"""
    build_matrix(F₁, F₂, N)

Compute the Carleman linearization matrix associated to the quadratic
system ``x' = F₁x + F₂(x⊗x)``, truncated at order ``N``.

### Input

- `F₁` -- sparse matrix of size ``n × n``
- `F₂` -- sparse matrix of size ``n × n^2``
- `N`  -- integer representing the truncation order, should be at least two

### Output

Sparse matrix `A`.

### Algorithm

See references [1] and [2] of CARLIN.md.
"""
function build_matrix(F₁, F₂, N; compress=true)
    if compress
        n = size(F1)[1]
        monoms = generate_monomials(n, N)
        monom_to_ind = Dict(m => i for (i, m) in enumerate(monoms))
        result = spzeros(length(monoms), length(monoms))
        for (ind, m) in enumerate(monoms)
            for (i, j, c) in zip(findnz(F₁)...)
                if m[i] > 0
                    deriv = m
                    if i != j
                        deriv = m .+ Tuple((k == i) ? -1 : ((k == j) ? 1 : 0) for k in 1:n)
                    end
                    result[ind, monom_to_ind[deriv]] = m[i] * c
                end
            end
    
            if sum(m) < N 
                for (i, j, c) in zip(findnz(F₂)...)
                    j0 = ((j - 1) % n) + 1
                    j1 = ((j - 1) ÷ n) + 1
                    if m[i] > 0
                        deriv = m .+ Tuple((k == i) ? -1 : ((k in [j0, j1]) ? 1 : 0) for k in 1:n)
                        result[ind, monom_to_ind[deriv]] += m[i] * c
                    end
                end
            end
        end
        return result
    end
 
    # No compression
    if N < 1
        throw(ArgumentError("expected the truncation order to be at least 1, got N=$N"))
    elseif N == 1
        _build_matrix_N1(F₁, F₂)
    elseif N == 2
        _build_matrix_N2(F₁, F₂)
    elseif N == 3
        _build_matrix_N3(F₁, F₂)
    elseif N == 4
        _build_matrix_N4(F₁, F₂)
    else
        _build_matrix_N(F₁, F₂, N) # general case
    end
end

"""
    generate_monomials(n, N)

returns a list of n-tuples of nonegative integers with the sum at most N
"""
function generate_monomials(n, N)
    if n == 1
        return [(i,) for i in 0:N]
    end
    result = []
    prev = generate_monomials(n - 1, N)
    for p in prev 
        for r in 0:(N - sum(p))
            push!(result, (r, p...))
        end
    end
    return result
End

function build_matrix_compressed(F1, F2, N)
    
end

function _build_matrix_N1(F₁, F₂)
    return F₁
end

function _build_matrix_N2(F₁, F₂)
    n = size(F₁, 1)
    a = hcat(kron_sum(F₁, 1), kron_sum(F₂, 1))
    b = hcat(spzeros(n^2, n), kron_sum(F₁, 2))
    return vcat(a, b)
end

function _build_matrix_N3(F₁, F₂)
    n = size(F₁, 1)
    a = hcat(kron_sum(F₁, 1), kron_sum(F₂, 1), spzeros(n, n^3))
    b = hcat(spzeros(n^2, n), kron_sum(F₁, 2), kron_sum(F₂, 2))
    c = hcat(spzeros(n^3, n), spzeros(n^3, n^2), kron_sum(F₁, 3))
    return vcat(a, b, c)
end

function _build_matrix_N4(F₁, F₂)
    n = size(F₁, 1)
    a = hcat(kron_sum(F₁, 1), kron_sum(F₂, 1), spzeros(n, n^3), spzeros(n, n^4))
    b = hcat(spzeros(n^2, n), kron_sum(F₁, 2), kron_sum(F₂, 2), spzeros(n^2, n^4))
    c = hcat(spzeros(n^3, n), spzeros(n^3, n^2), kron_sum(F₁, 3), kron_sum(F₂, 3))
    d = hcat(spzeros(n^4, n), spzeros(n^4, n^2), spzeros(n^4, n^3), kron_sum(F₁, 4))
    return vcat(a, b, c, d)
end

function _build_matrix_N(F₁, F₂, N)
    @assert N >= 3 "expected N to be at least 3, got N=$N"
    n = size(F₁, 1)

    out = Vector{typeof(F₁)}()
    for j in 1:N
        if j == N
            F12_j = kron_sum(F₁, j)
            Zleft_j = spzeros(n^j, sum(n^i for i in 1:j-1))
            push!(out, hcat(Zleft_j, F12_j))
        else
            F12_j = hcat(kron_sum(F₁, j), kron_sum(F₂, j))
            if j == 1
                Zright_j = spzeros(n^j, sum(n^i for i in j+2:N))
                push!(out, hcat(F12_j, Zright_j))
            elseif j == N-1
                Zleft_j = spzeros(n^j, sum(n^i for i in 1:j-1))
                push!(out, hcat(Zleft_j, F12_j))
            else # general case
                Zleft_j = spzeros(n^j, sum(n^i for i in 1:j-1))
                Zright_j = spzeros(n^j, sum(n^i for i in j+2:N))
                push!(out, hcat(Zleft_j, F12_j, Zright_j))
            end
        end
    end
    return reduce(vcat, out)
end
