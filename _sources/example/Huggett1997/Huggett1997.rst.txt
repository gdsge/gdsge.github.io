**************************************************************************************
Huggett (1997): Steady States and Transition Paths in Heterogeneous Agent Models
**************************************************************************************

========================
The Model
========================

We use the seminal work `Huggett (1997) <https://www.sciencedirect.com/science/article/pii/S0304393297000251>`_ to illustrate
how the toolbox can be used to solve steady states and transition paths of a heterogeneous-agent model.
The example also demonstrates how to conduct non-stochastic simulations using the toolbox,
by keeping track of the distribution function over a refined grid of individual state variables.

Though the toolbox is not designed for solving the equilibrium of this type of model directly,
since the decision problem is characterized by an equation system (the Euler equation 

.. math::
    u'(c_t) = \beta \mathbb{E}_t[(1-\delta+r_{t+1})u'(c_{t+1}] + \lambda_t,
where :math:`\lambda_t` is the Lagrange multiplier on the borrowing constraint,and complementary-slackness condition, :math:`\lambda_t k_{t+1}=0`) with state transition functions, it readily fits in the toolbox's general framework.
One just needs an extra fixed-point loop to update the equilibrium object, which can be coded in MATLAB. 
For the one-sector model studied by `Huggett (1997) <https://www.sciencedirect.com/science/article/pii/S0304393297000251>`_, the steady state equilibrium object is the aggregate capital stock; the transition path equilibrium object is the time sequence
of the aggregate capital stock.

We directly define the equilibrium, which covers all the ingredients we need for computing the model. For the full description of the model, 
see `Huggett (1997) <https://www.sciencedirect.com/science/article/pii/S0304393297000251>`_ .

A sequential equilibrium is a time sequence of (1) policy functions :math:`c_{t}(k,e)`, :math:`\lambda_t(k,e)`, :math:`k'_t(k,e)`; (2) measures over individual states :math:`\phi_t`; 
(3) aggregate prices and quantities :math:`w_t, r_t, K_t`, s.t. 

1. :math:`c_t(k,e), \lambda_t(k,e), k_t'(k,e)` satisfy individuals' optimality conditions. That is, they solve

.. math::
    c_t(k,e)^{-\sigma}=\beta(1+r_{t+1})E[c_{t+1}(k_t'(k,e),e')^{-\sigma} | e] + \lambda_t(k,e),
    \\
    k_t'(k,e)\lambda_t(k,e)=0, \quad \lambda_t(k,e)\geq0, \quad k_t'(k,e)\geq0,
    \\
    c_t(k,e)+k_t'(k,e)=k(1+r_t)+w_te.

2. Prices are competitively determined and markets clearing:

.. math::
    r_t = \alpha K_t^{\alpha-1}-\delta
    \\
    w_t = (1-\alpha) K_t^{\alpha}
    \\
    K_t = \int k \  \phi_t(dk,de)

3. :math:`\phi_t` are consistent with the transitions implied by policy functions and exogenous shocks.

A steady-state equilibrium is a sequential equilibrium with time-invariant equilibrium objects.

Notice we have transformed the individual's optimization problem into first order conditions and complementarity slackness conditions, 
which enable us to solve the decision problem with the toolbox.

=============================
The gmod File and MATLAB File
=============================

:download:`huggett1997.gmod <huggett1997.gmod>`

.. literalinclude:: huggett1997.gmod
    :linenos:
    :language: GDSGE

The MATLAB file that calls the toolbox codes and manually update equilibrium objects :download:`main.m <main.m>`

.. literalinclude:: main.m
    :linenos:
    :language: MATLAB

==================
Output
==================

The code produces the stationary distribution 

.. image:: figures/stationary_dist.png
    :scale: 50 %

the transition path starting from an equal wealth distribution (see the MATLAB file for how the initial distribution is constructed)

.. image:: figures/transition_path.png
    :scale: 50 %

and the policy functions at the steady state.

.. image:: figures/policy_function_kp.png
    :scale: 50 %