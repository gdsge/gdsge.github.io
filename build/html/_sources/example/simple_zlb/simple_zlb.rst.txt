*************************************************************************************
Comparison with OccBin: A Simple Model with an Occasionally Binding Interest Rate ZLB
*************************************************************************************

.. _SIMPLE_ZLB:

In `Guerrieri and Iacoviello (2015) <https://www.sciencedirect.com/science/article/pii/S0304393214001238>`_
the authors developed a toolbox, OccBin, which solves models with occasionally binding constraints by a piecewise linear algorithm based on Dynare. 
To highlight the connections with OccBin, and introduce GDSGE to researchers who are already familiar with Dynare and OccBin,
we solve the model in Subsection 2.4 of Guerrieri and Iacoviello (2015), a simple model with an occasionally binding lower bound on the interest rate.

===============
The Model
===============

Asset price q is determined by the intertemporal asset pricing equation:

.. math::
    q_{t}=\beta\left(1-\rho\right)\mathbb{E}_{t}q_{t+1}+\rho q_{t-1}-\sigma r_{t}+u_{t},
    :label: eq_asset_price
    
where :math:`\mathbb{E}_{t}` is the conditional expectation operator,
and :math:`\beta, \rho, \sigma` are parameters.
The current value of :math:`q_{t}` depends on its previous value, 
its expected future value, the net interest rate :math:`r_{t}`, 
and an exogenous shock :math:`u_{t}`, which follows the following AR(1) process:

.. math::
    u_{t}=\rho_{u}u_{t-1}+\sigma_{u}\epsilon_{t}, \text{with } \epsilon_{t}\sim N\left(0,1\right).
    
:math:`r_{t}` follows a simple feedback rule with an occasionally binding lower bound: 

.. math::
    r_{t}=\max\left\{ \phi q_{t},\underline{r}\right\},
    :label: eq_interest_rate_rule
    
where parameter :math:`\phi>0`. The max operator prevents :math:`r_{t}` from falling below a certain threshold :math:`\underline{r}`. 

Denote value of q in the previous period as :math:`q_{-1}`, and its future value as :math:`q^{\prime}`.
A recursive competitive equilibrium consists of functions :math:`q\left(q_{-1},u\right), r\left(q_{-1},u\right)` s.t.

.. math::
    q\left(q_{-1},u\right)	=\beta\left(1-\rho\right)\mathbb{E}\left[q^{\prime}\left(q\left(q_{-1},u\right),\rho_{u}u+\sigma_{u}\epsilon^{\prime}\right)\right]+\rho q_{-1}-\sigma r\left(q_{-1},u\right)+u,
    \\
    r\left(q_{-1},u\right)	=\max\left\{ \phi q\left(q_{-1},u\right),\underline{r}\right\}.

This recursive system can be solved using a time iteration procedure similar to the one for the :ref:`standard RBC model <simpleRBC>`.
In the period-t time step, we take the function :math:`q_{t+1}\left(q,u^{\prime}\right)` as given,
and solve for :math:`q_{t}` and :math:`r_{t}` by the following system of equations
at each collocation of :math:`\left\{ q_{-1},u\right\}`:

.. math::
    q_{t}\left(q_{-1},u\right)	=\beta\left(1-\rho\right)\mathbb{E}\left[q_{t+1}\left(q_{t}\left(q_{-1},u\right),\rho_{u}u+\sigma_{u}\epsilon^{\prime}\right)\right]+\rho q_{-1}-\sigma r_{t}\left(q_{-1},u\right)+u,
    \\
    r_{t}\left(q_{-1},u\right)	=\max\left\{ \phi q_{t}\left(q_{-1},u\right),\underline{r}\right\} .


=======================================
GDSGE v.s OccBin
=======================================

The recursive system can now be input to the GDSGE toolbox via a gmod file :download:`simple_zlb.gmod <simple_zlb.gmod>`, listed below.

.. literalinclude:: simple_zlb.gmod
    :linenos:
    :language: GDSGE

.. image:: figures/compare_occbin.png
    :scale: 50 %

The figure above displays the solutions of GDSGE and compare them with piecewise-linear solutions by OccBin, and linear solutions by Dynare.
In general, the piecewise-linear solution is close to the nonlinear solution, but there are some differences,
especially when the shock size is below the cutoff value (around :math:`u_{t}=-0.08`) at which the lower bound on :math:`r_{t}` starts to bind. 
In this region OccBin yields higher asset prices than GDSGE does. 
The reason is that OccBin assumes no future shock innovations when it solves for the current asset price :math:`q_{t}`. 
Because the asset pricing function is concave, this assumption implies a higher expected value of future asset price :math:`q_{t+1}` (by Jensen's inequality) than the true expected value. 
Consequently, from the intertemporal asset pricing equation :eq:`eq_asset_price`, :math:`q_{t}` is higher in OccBin solution than in the GDSGE solution.

.. image:: figures/compare_occbin_simple.png
    :scale: 50 %

In the above figure, we provide a line by line comparison of the mod files that are used to solve this model by OccBin and GDSGE.
Since OccBin is designed as an add-on to Dynare, most of the differences in the structure here have been illustrated in :ref:`the translation from Dynare example <COMPARE_DYNARE>`.
Here we choose to highlight two key implementation differences between OccBin and GDSGE.
First, users of OccBin need to write two Dynare mod files corresponding to the
two separate regimes - one with nonbinding lower bound on the interest rate in equation :eq:`eq_interest_rate_rule`
and the other one with binding constraint - as in the left-most and middle files in the figure.
Notice that Line 32 in both files sets the equilibrium interest rate to different values depending on whether the lower bound binds.
Then OccBin solves the model dynamics after an exogenous shock
by conjecturing the future periods in which each regime applies and updating this conjecture over iterations using its companion Matlab codes.
In contrast, GDSGE requires a single gmod file (the right-most file in the figure)
to accommodate both regimes together in a self-contained script,
and which regime applies is an endogenous equilibrium outcome as described in Line 32 of the file.
Second, OccBin requires a fixed exogenous shock as input.
Thus to plot the policy functions in the figure,
OccBin needs to be called repeatedly for each value in the grid of :math:`u_{t}` on the abscissae
(21 times in this example and more if one uses finer grid).
On the contrary, GDSGE can handle different values of state variables at once, as in Lines 18-19 in the GDSGE file.

With that being said, Occbin has its own merits relative to GDSGE.
First, the piecewise linear perturbation method it uses can solve, and estimate models with a large number of state variables very quickly.
Second, Occbin is designed to generate impulse response functions directly,
while users of GDSGE need to generate the impulse response functions by simulation after the policy functions are solved.
See an example :ref:`here. <KM1997>`