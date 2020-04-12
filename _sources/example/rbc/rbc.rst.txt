************************************
Getting Started - A Simple RBC Model
************************************

===============
The Model
===============
The model is a canonical complete-markets Real Business Cycle (RBC) model with a single productivity shock.
This simple model can be approximated with linear solutions well,
so using GDSGE to obatin global non-linear solutions is not necessary.
Nevertheless it serves as a good starting point to illustrate the basic usage of the toolbox,
as this model should be familiar to any macroeconomic audience.

Time is discrete :math:`t=0...\infty`. Representative households with mass one maximize utility

.. math::
    \mathbb E \sum_{t=0}^{\infty} \beta^t \frac{c_t^{1-\sigma}}{1-\sigma},
    
where parameter :math:`\beta>0` is the discount factor, :math:`\sigma>0` is the coefficient of relative risk aversion. :math:`c_t` is the consumption. :math:`\mathbb{E}` is an expectation operator integrating the productivity shock to be introduced below.

Competitive representative firms produce a single output according to

.. math::
    Y_t=z_t K_t^{\alpha} L_t^{1-\alpha},

where parameter :math:`\alpha \in (0,1)` is the capital share. :math:`K_t` is capital, :math:`L_t` is labor, and :math:`z_t\in\{z_L,z_H\}` is the productivity shock which follows a two-point Markov process with the following transition matrix

.. math::
    \left(
    \begin{aligned}
    \pi_{LL} \quad 1-\pi_{LL}\\
    1-\pi_{HH} \quad \pi_{HH}
    \end{aligned}
    \right).
    
Capital depreciates at rate :math:`\delta \in (0,1)`. Investment technology can convert one unit of output to new capital:

.. math::
    K_{t+1} = K_t(1-\delta) + I_t.
    
Assets markets are complete. Households make investment decision and supply capital and labor to firms. Market clearing conditions for labor and goods are, respectively,

.. math::
    L_t=1, \\
    c_t+I_t=Y_t.
    
The complete-markets equilibrium can be characterized by the Euler equation and the goods market clearing condition:

.. math::
    c_t^{-\sigma}=\beta \mathbb{E}_t \left[\left ( \alpha z_{t+1} K_{t+1}^{\alpha-1}+(1-\delta)\right)c_{t+1}^{-\sigma}\right], \\
    c_t+K_{t+1} = z_tK_t^{\alpha}+(1-\delta)K_t.
    :label: sequential_equation

    
Given :math:`K_0`, a sequential competitive equilibrium is stochastic processes :math:`(c_t,K_{t+1})` that satisfy system :eq:`sequential_equation`. To input the system into GDSGE, we need to write the system in a recursive form. 

Definition: a recursive competitive equilibrium is functions :math:`c(z,K), K'(z,K)` s.t.

.. math::
    c(z,K)^{-\sigma}=\beta \mathbb{E}\left[ \left (\alpha z' [K'(z,K)]^{\alpha-1}+(1-\delta)\right)[c(z',K'(z,K))]^{-\sigma} \Big| z \right]
    \\
    c(z,K)+K'(z,K)=zK^{\alpha} + (1-\delta)K.

The recursive system can be solved using a time iteration procedure:

.. math::
    c_t(z,K)^{-\sigma}=\beta \mathbb{E}\left[ \left (\alpha z' [K_t'(z,K)]^{\alpha-1}+(1-\delta)\right)[c_{t+1}(z',K_t'(z,K))]^{-\sigma} \Big| z \right]
    \\
    c_t(z,K)+K'_t(z,K)=zK^{\alpha} + (1-\delta)K.

taking function :math:`c_{t+1}(z,K)` as known in the period-:math:`t` time step.

===============
The gmod File
===============

The recursive system can now be input to GDSGE via a mod file :download:`rbc.gmod <rbc.gmod>` below.

.. literalinclude:: rbc.gmod
    :linenos:
    :language: GDSGE

The gmod file can be inputted to a local GDSGE compiler or uploaded to the online compiler at http://www.gdsge.com/ (Remember also to download the necessary runtime files following the instruction
on the compiler website). 
The compiler returns three files that can be used to solve and simulate the model: iter_rbc.m, simulate_rbc.m, mex_rbc.mexw64. 

First, call iter_rbc.m in matlab to run the policy iterations, which produces

.. code-block:: text

    >> IterRslt = iter_rbc;

    Iter:10, Metric:0.385607, maxF:9.99011e-09
    Elapsed time is 0.174117 seconds.
    
    ...
    
    Iter:323, Metric:9.89183e-07, maxF:7.96886e-09
    Elapsed time is 0.027923 seconds.
    
where *Metric* is the maximum absolute distance of *var_interp* between the current and the last iteration,
and *maxF* is the maximum absolute equation residual across all collocation points in the current iteration.
As shown, the converged criterion by default is *Metric* smaller than :math:`1e-6`, and can be overwritten by the option *TolEq* that can be put into the gmod file or
supplied in an option structure when calling *iter_rbc* (see details below).

The returned IterRslt contains the converged policy and state transition functions. For example, we can plot the policy function for consumption :math:`c`:

.. code-block:: text

    >> plot(IterRslt.var_state.K, IterRslt.var_policy.c);
    xlabel('K'); title('Policy Functions for c');
    
.. image:: figures/policy_c.png
    :scale: 50 %

We can now simulate the model by inputting IterRslt into simulate_rbc:

.. code-block:: text

    >> SimuRslt = simulate_rbc(IterRslt);

    Periods: 1000
       shock       K       c
           1   38.09   2.754
    Elapsed time is 1.185821 seconds.
    
    ...
    
    Periods: 10000
       shock       K       c
           2   37.83   2.753
    Elapsed time is 1.281338 seconds.
    
The returned SimuRslt contains a panel of simulated paths with num_samples and num_periods specified in the mod file. For example, we can plot the histogram of state variable :math:`K`:

.. code-block:: text

    >> histogram(SimuRslt.K); title('Histogram for K');
    
.. image:: figures/histogram_K.png
    :scale: 50 %

Or we can plot the first two sample paths of wages for the first 100 periods:

.. code-block:: text

    >> plot(SimuRslt.w(1:2,1:100)'); title('Sample Paths of Wages');
    
.. image:: figures/sample_path_w.png
    :scale: 50 %

The iter and simulate files can be reused by passing parameters to be overwritten in a struct. For example,

.. code-block:: Matlab

    >> options.sigma = 1.5 % overwrite sigma
    options.z = [0.95,1.05] % making the shock larger
    IterRslt = iter_rbc(options);
    SimuRslt = simulate_rbc(IterRslt,options);

Part of the toolbox options can also be overwritten by including them in the struct. See :ref:`Options`.
    
=========================
Dissecting the gmod File
=========================

We now look into each line of rbc.gmod and describe the usage.

.. literalinclude:: rbc.gmod
    :lines: 1-6 
    :lineno-start: 1
    :language: GDSGE

A line starting with keyword `parameters` declares parameters.
Parameters are variables used in the *model* block that are invariant across states or over time.
Matlab-style inline comments can be used following a "%".

.. literalinclude:: rbc.gmod
    :lines: 8-17 
    :lineno-start: 8
    :language: GDSGE

Exogenous states such as the productivity shock in the RBC model should be declared following keyword *var_shock*.
The number of states should be specified in variable *shock_num*.
The Markov transition matrix should be specified in variable *shock_trans*.
Notice that any Matlab expressions such as :code:`z_low = 0.99` can be evaluated outside the *model* block.

For multi-dimension exogenous states, *shock_num* needs to be specified as the number of discretze points in the Cartesian set across
all dimensions. *shock_trans* should be specified as the full transition matrix accordingly. 
Matlab functions *ndgrid* and *kron* can be used to construct the Cartesian set and the full transition matrix.

If an exogenous state follows a continuous process such as AR(1), specify the state to be an endogenous state instead in *var_state*,
and discretize the innovation.

.. literalinclude:: rbc.gmod
    :lines: 19-25
    :lineno-start: 19
    :language: GDSGE

Endogenous states such as capital in the RBC model should be declared following keyword *var_state*.
Then the discretized grid for each state should be specified (e.g., :code:`K = linspace(KMin,KMax,KPts);` in the example).
Notice that any Matlab expressions (such as function *linspace* here) can be evaluated.

The discretized grid will be used in fixed-grid function approximation procedures such as splines and linear interpolations.
For adaptive grid methods, only the range of the grid will be used.

.. literalinclude:: rbc.gmod
    :lines: 27-31
    :lineno-start: 27
    :language: GDSGE

The time iteration procedure requires taking the state transition functions (here, implicitly defined in :math:`c_{t+1}(z,K)`) as given 
when evaluating the system of equations. These state transition functions are declared following keyword *var_interp*.
They are named *var_interp* since they are usually evaluated with some function approximation procedure such as interpolation in evaluating the system of equations.

Each of the transition functions needs to be initialized following keyword *initial*.
Here :math:`c_{t+1}(z,K)` is initialized as :math:`zK^{\alpha} + (1-\delta)K` which means that consumers just 
consumer all resources that include output and non-depreciated capital. This initialization basically 
requests the toolbox to find the equilibrium that corresponds to the limit of a finite-horizon economy taking the number of horizons to infinity,
of which :math:`c_{t+1}` is initialized to be the last-period solution.
Notice that the Matlab "dot" operator (.*) works in the line following *initial*, and relevant tensors are formed automatically.

In general, it is crucial to form a good initial guess on the transition functions to make the policy iteration method work.
Starting with a last-period problem is shown to
deliver both good theoretical properties and robust numerical computations (`Cao, 2018 <https://academic.oup.com/ej/article/128/614/2258/5230957>`_). 
See :ref:`Mendoza (2010) <Mendoza2010>` for an example on how to define a more complex last-period problem that may require solving a different system of equations, through a *model_init* block.

The update of the transition function after a time iteration step needs to be specified such as :code:`c_interp = c;`.
The update can use any variables returned as part of the solution to the system in the current time iteration step. 
For example, here :code:`c_interp = c;` means that the *c_interp* variable is updated with *c* after a time iteration,
where *c* is one of the policy variables solved by the system of equations, specified in the gmod file as below.

.. literalinclude:: rbc.gmod
    :lines: 33-36
    :lineno-start: 33
    :language: GDSGE

All policy variables that enter the equations as unknowns are declared following keyword :declare:`var_policy`.
For each of these variables, the bounds for where the equation solver searches the solution should be specified
following keyword *inbound*. For variables of which the bounds cannot be determined ex-ante, 
specify tight bounds for them and use an *adaptive* option so the solver adjusts bounds automatically when it cannot find solutions 
and adapt bounds across time iterations. See :declare:`var_policy` in :ref:`Variable Declaration`.

.. literalinclude:: rbc.gmod
    :lines: 38-39
    :lineno-start: 38
    :language: GDSGE

Some policy variables can be evaluated as simple functions of states and other policy variables, so they do not have to be
directly included in the system of equations. For example wage is determined by the marginal product of labor
and can be evaluated according to :math:`w=(1-\alpha)zK^{\alpha}`. These policy variables can be declared
following keyword :declare:`var_aux`.

.. literalinclude:: rbc.gmod
    :lines: 41-61
    :lineno-start: 41
    :language: GDSGE

The *model;---end;* block defines the system of equations for each collocation point of endogenous states and exogenous states. 
For the current example, it simply defines the system of equations for each collocation point :math:`(z,K)`.

The equations should be eventually specified in the *equation;---end;* block, in which each line corresponds to one equation in the system.
Any calculations in order to evaluate these equations are included in the *model* block preceding the *equations* block.
Notice the whole *model* block is parsed into C++, so all evaluations should be scalar-based: Matlab functions such as .* operator cannot be used. 
Nevertheless, the *model* block supports simple control-flow blocks in Matlab-style syntax, such as if-elseif-else-end block and 
for-end block.

A variable followed by a prime (') indicates that the variable is a vector of length *shock_num*. 
For example,

.. literalinclude:: rbc.gmod
    :lines: 44-44
    :lineno-start: 44
    :language: GDSGE

means that

.. code-block:: text

    mpk_next(1) = z(1)*alpha*K_next^(alpha-1) + 1-delta
    mpk_next(2) = z(2)*alpha*K_next^(alpha-1) + 1-delta

A `var_shock` (here :code:`z`), when used followed by a prime ('), corresponds to the vector of the variable across all possible exogenous states, and thus can be
used to construct other vector variables. Notice when a `var_shock` is used not followed by a prime, it corresponds to the exogenous state at the current collocation point, e.g., :code:`z` in

.. literalinclude:: rbc.gmod
    :lines: 52-52
    :lineno-start: 52
    :language: GDSGE

Any *var_interp* declared before can be used as a function in the model block. For example,

.. literalinclude:: rbc.gmod
    :lines: 47-47
    :lineno-start: 47
    :language: GDSGE

means calculating :math:`c_{t+1}` based on the state transition function implied by *c_interp*, at
the next-period endogenous state *K_next* (which is a current policy variable).
Where are the next-period exogenous states? These are taken care of by the prime (') operator
following *c_interp*, which means that it is evaluating at each realization of the future exogenous states,
and returning a vector of length shock_num. Accordingly, the left hand side variable should be declared as a vector,
i.e., a variable followed by a prime (').

The *model* block can use several built-in functions for reduction operations.
For example, the *GDSGE_EXPECT{}* used in 

.. literalinclude:: rbc.gmod
    :lines: 51-51
    :lineno-start: 51
    :language: GDSGE

is to calculate the conditional expectation of the object defined inside the curly braces,
conditional on the current exogenous state, using the default Markov transition matrix *shock_trans*.
Obviously, this function is meaningful only if it takes as argument the realizations of variables across future exogenous states,
which are defined as vector variables followed by prime (').

This operator can also take a different transition matrix than *shock_trans*, which is used as
:code:`GDSGE_EXPECT{*|alternative_shock_trans}`. This can be used to solve models with heterogeneous beliefs. 
See example :ref:`Cao (2018) <Cao2018>`.

Two other reduction operations *GDSGE_MAX{}* and *GDSGE_MIN{}* are defined, which are to take
the maximum and the minimum of objects inside the curly braces, respectively. See :ref:`Built-in functions`.

.. literalinclude:: rbc.gmod
    :lines: 63-70
    :lineno-start: 51
    :language: GDSGE

The simulate block defines how the file for Monte Carlo simulations should be generated.
It should define the initial endogenous state following keyword *initial*.
``initial K Kss;`` in the example sets the endogenous state :math:`K` to *Kss* defined before.

The simulate block should define the initial exogenous state index following keyword *initial shock*.
It should define the variables to be recorded following *var_simu*. 
It should define the transition for each state variable. In the example, ``K'=K_next;``
defines that the next period endogenous state :math:`K` should be assigned to *K_next* which is one of
the *var_policy* solved as part of the system. Notice the prime operator (') following *K* 
indicates that the line is to specify the transition of an endogenous state variable in the simulation, 
which has a different meaning than the prime operator (') used in the *model* block. 
Nevertheless, the prime operators (') in both usages are associated with the transition to the future state, and thus motivate such designs.

The simulate block can also overwrite num_periods (default 1000) and num_samples (default 1).

=====================
What's Next?
=====================

The current example demonstrates the basic usage of the toolbox.
You can proceed to :ref:`an extension with investment irreversibility <A RBC Model with Irreversible Investment>` that requires a global method, 
or to a real example :ref:`Heaton and Lucas (1996) <Heaton and Lucas (1996): Incomplete Markets with Portfolio Choices>` which is the leading example in the toolbox paper.

Or you can proceed to :ref:`Toolbox API`.
