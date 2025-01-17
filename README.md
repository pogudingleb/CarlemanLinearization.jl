# CarlemanLinearization.jl

[![Build Status](https://github.com/JuliaReach/CarlemanLinearization.jl/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/JuliaReach/CarlemanLinearization.jl/actions/workflows/ci.yml?query=branch%3Amaster)
[![Documentation](https://img.shields.io/badge/docs-latest-blue.svg)](https://juliareach.github.io/CarlemanLinearization.jl/dev/)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)](https://github.com/juliareach/CarlemanLinearization.jl/blob/master/LICENSE)
[![Code coverage](http://codecov.io/github/JuliaReach/CarlemanLinearization.jl/coverage.svg?branch=master)](https://codecov.io/github/JuliaReach/CarlemanLinearization.jl?branch=master)
[![Join the chat at https://gitter.im/JuliaReach/Lobby](https://badges.gitter.im/JuliaReach/Lobby.svg)](https://gitter.im/JuliaReach/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

This package implements the Carleman linearization transformation of polynomial
differential equations in Julia.

## Features

The following methods are available:

- Construction of the Carleman embedding using sparse matrices
- Explicit error bounds [FP17]
- Improved error bounds for dissipative systems [L20]

## Related libraries

- [carlin](https://github.com/mforets/carlin): Python library with similar functionality.
- [CarlemanBurgers](https://github.com/hermankolden/CarlemanBurgers): MATLAB implementation of the classical Carleman solution of the viscous Burgers equation, used in https://arxiv.org/abs/2011.03185.

## References

- [[FP17] Forets, Marcelo, and Amaury Pouly. Explicit error bounds for carleman linearization. arXiv preprint arXiv:1711.02552 (2017).](https://arxiv.org/abs/1711.02552)

- [[L20] Liu JP, Kolden HØ, Krovi HK, Loureiro NF, Trivisa K, Childs AM. Efficient quantum algorithm for dissipative nonlinear differential equations. arXiv preprint arXiv:2011.03185. 2020 Nov 6.](https://arxiv.org/abs/2011.03185)
