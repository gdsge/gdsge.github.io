**************************************************************************************
A Multi-country Business Cycle Model
**************************************************************************************

.. _mc_rbc:
===============
The Model
===============

In this example we demonstrate the toolbox's ability to handle models with high dimensional states, thanks to the sparse-grid interpolation method.
The model is a complete-markets multi-country business cycle model. We show that the model with 15 countries and 30 continuous states can be solved in 10 minutes with decent accuracy on a regular desktop.

There are :math:`N` countries, indexed by :math:`j`. Each country has one unit of consumers that supply labor exogenously. The consumers' preference reads

.. math::
    \mathbb{E}_0 \sum_{t=0}^{\infty}\beta^t u(c_{j,t}).

Production in a country :math:`j` takes capital and labor according to a Cobb-Douglas production function:

.. math::
    Y_{j,t}=\exp(z_{j,t})K_{j,t}^{\alpha},

where :math:`K_{j,t}` is capital and :math:`z_{j,t}` is the log of country-j's productivity that follows an AR(1) process, which is independently distributed across countries. 
Capital and labor are immobile.  Capital depreciates at rate :math:`\delta` and  investment follows a standard technology:

.. math::
    K_{j,t+1} =(1-\delta)K_{j,t} + i_{j,t}.


The market is complete in that consumers can trade a full menu of Arrow securities.

=======================
Equilibrium Conditions
=======================

The complete-markets equilibrium can be characterized by the social planner's solution:

.. math::
    \max_{c_{j,t},i_{j,t},K_{j,t+1}} \mathbb{E}_0 \sum_j \omega_j  \sum_{t=0}^{\infty} \beta^t u(c_{j,t}),
    \\
    s.t. \quad \sum_j (c_{j,t}+i_{j,t})=\sum_j \exp(z_{j,t})K_{j,t}^{\alpha},
    \\
    K_{j,t+1} =(1-\delta)K_{j,t} + i_{j,t},
    \\
    \Rightarrow s.t.  \quad \sum_j (c_{j,t}+K_{j,t+1})=\sum_j \exp(z_{j,t})K_{j,t}^{\alpha}+(1-\delta)K_{j,t},

where :math:`\omega_j` is the Pareto weight assigned to consumers in country :math:`j` that depends on the initial distribution of Arrow securities.  The first order conditions read

.. math::
    \omega_j  u'(c_{j,t})=\lambda_t,
    \\
    -\lambda_t +\beta E_t \lambda_{t+1}[MPK_{j,t+1} + (1-\delta)]=0,
    
where :math:`MPK_{j,t}\equiv \alpha \exp(z_{j,t})K_{j,t}^{\alpha-1}`, and :math:`\lambda_t` is the Lagrangian multiplier associated with the world resource constraint.
Therefore, the equilibrium conditions can be  stated as:

.. math::
    -\lambda_t + \beta \mathbb{E}_t \lambda_{t+1}[MPK_{j,t+1} + (1-\delta)]=0, \forall j
    \\
    \sum_j (c_{j,t}+K_{j,t+1})=\sum_j \exp(z_{j,t})K_{j,t}^{\alpha}+(1-\delta)K_{j,t},

for equilibrium objects :math:`(\lambda_t,K_{j,t+1})`, where

.. math::
    c_{j,t}=u'^{-1}(\frac{\lambda_t}{\omega_j}).

=======================
Solutions
=======================
We solve the recursive equilibrium defined over the state vector :math:`(z_1,z_2,...,z_N,K_1,K_2,...,K_N)` of length :math:`2\times N`. The model does not admit an analytical solution despite being simple. The numerical solution is challenging as the dimension of state space is high, and interpolation methods based on dense grids face the curse of dimensionality. In particular, the number of collocation points increases exponentially in the dimension if dense-grid methods are used. Instead, we use the adaptive-grid method that is shipped with the toolbox, with which the number of collocation points only increases in the dimension in a polynomial speed.

The gmod code is listed below where one can find the detailed parameterization (:download:`rbc <rbc.gmod>`).

.. literalinclude:: rbc.gmod
    :linenos:
    :language: GDSGE

The code utilizes the macro feature of the toolbox. For example, the code block

.. literalinclude:: rbc.gmod
    :lines: 42-45
    :lineno-start: 42
    :language: GDSGE

expands to 

.. code-block:: GDSGE

    var_state z1;
    z1 = linspace(zMin,zMax,zPts); % placeholder

    var_state z2;
    z2 = linspace(zMin,zMax,zPts); % placeholder
    
    ...
    
    var_state z15;
    z15 = linspace(zMin,zMax,zPts); % placeholder

The line

.. literalinclude:: rbc.gmod
    :lines: 121-121
    :lineno-start: 121
    :language: GDSGE

expands to

.. code-block:: GDSGE

    lambda_future = lambda_interp(shock,z_next(1),z_next(2),...,z_next(N),K_next(1),K_next(2),...,K_next(N));

The strategy we use for integrating over future shocks follows the monomial integration proposed by `Judd, Maliar and Maliar (2011, QE) <https://onlinelibrary.wiley.com/doi/abs/10.3982/QE14>`_,
which calculates the integration by perturbing future innovation from zero along one dimension at a time. This is implemented by Line 118-139 of the code.

The policy functions can be solved by simply calling *iterRslt = iter_rbc.m* after the gmod is compiled. The policy iteration takes around 10 minutes on a regular desktop (with a 12-core 2.5GHz CPU).

Simulation, however, requires some manual configuration as now we need to feed in shocks generated from the actual AR(1) processes, instead of the realizations of shocks used for integration in solving the policy functions. Please refer to :download:`main_simulate <main_simulate.m>` for how to generate a Markov process using MATLAB's built-in functions, and feed in the simulated processes into
the toolbox-generated code. 

The file also contains procedures in calculating the Euler equation errors. The unit-free Euler equation error is defined as

.. math::
    \mathcal{E}_{j,t}=\Big|-1+\frac{ \beta \mathbb{E}_t u'(c_{j,t+1})[MPK_{j,t+1} + (1-\delta)]}{u'(c_{j,t})}\Big|.

The error given one state can be calculated by simulating a large sample one period forward starting from this state, and integrating over these sample paths. The script file implements this procedure and reports the max and mean errors for a sample of states drawn from the ergodic distribution (running the calculation requires 16GB memory; set the number of paths lower to reduce the memory requirement). The max error is 6.4E-4 and the mean error is 5.7E-4 across states in the ergodic set, demonstrating that the solutions are obtained with decent accuracy, despite the very sparse grid used for interpolation.

==========================
What's next
==========================
The current example demonstrates that the toolbox can handle models with high dimensional states, with dimension up to 30 on a regular desktop/laptop. However, we note that providing an accurate global solution to a highly-nonlinear albeit low-dimensional model is often much harder than providing a solution to a high-dimensional but less nonlinear model. Nevertheless, this means that one can solve standard medium New-Keynesian models with the toolbox (e.g., the benchmark model in Smets and Wouters (2007) has 9 exogenous and 11 endogenous state variables), and extend these models with nonlinear features such as an occasionally binding interest rate zero lower bound as in :ref:`the ZLB example <zlb>`.