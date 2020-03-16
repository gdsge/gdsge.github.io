*****************************************************************
Barro et al. (2017): Safe Assets with Rare Disasters
*****************************************************************

The model studies the creation of safe assets (risk-free bonds) between two agents with different 
risk aversion levels, in an endowment economy with rare disaster shocks. The model serves as an example to demonstrate how 
the toolbox can accommodate general recursive preferences such as `Epstein and
Zin (1989) <https://www.jstor.org/stable/1913778?seq=1#metadata_info_tab_contents>`_ - 
`Weil (1990) <https://www.jstor.org/stable/2937817?seq=1#metadata_info_tab_contents>`_, which is a common preference specification in the asset pricing and 
macro finance literature. The example also demonstrates that the solution method can handle
ill-behaved equilibrium systems robustly: in the context of `Barro et al. (2017) <https://www.nber.org/papers/w20652>`_, when the risk aversion level is set very high
(e.g., with coefficient of Relative Risk Aversion up to 100),the traditional
nested fixed point solution method becomes unstable,  since agents' portfolio choice becomes super sensitive to the pricing function.
Nevertheless, the toolbox, which solves the equilibrium as one single system of equations, 
can handle such parameterization fairly easily and uncovers novel theoretical results.

===============
The Model
===============

There are two groups of agents, :math:`i=1,2` in the economy. Agents have
an `Epstein and
Zin (1989) <https://www.jstor.org/stable/1913778?seq=1#metadata_info_tab_contents>`_ - 
`Weil (1990) <https://www.jstor.org/stable/2937817?seq=1#metadata_info_tab_contents>`_ utility function.
The coefficients of risk aversion satisfy :math:`\gamma_{2}\geq\gamma_{1}>0`,
i.e., agent 1 is less risk-averse than agent 2. The other parameters
between these two groups are the same. There is a replacement rate
:math:`\upsilon` at which each type of agents move to a state that has
a chance of :math:`\mu_{i}` of switching into type :math:`i`. Taking the potential
type shifting into consideration, their utility function can be written
as 

.. math::

    U_{i,t}=\left\{ \frac{\rho+\upsilon}{1+\rho}C_{i,t}^{1-\theta}+\frac{1-\upsilon}{1+\rho}\left[\mathbb{E}_{t}\left(U_{i,t+1}^{1-\gamma_{i}}\right)\right]^{\frac{1-\theta}{1-\gamma_{i}}}\right\} ^{1/\left(1-\theta\right)}.\label{eq:utility SafeAssets}

In this economy, there is a Lucas tree generating consumption good
:math:`Y_{t}` in period :math:`t` consumed by both agents. :math:`Y_{t}` is subject
to identically and independently distributed rare-disaster shocks.
With probability :math:`1-p`, :math:`Y_{t}` grows by the factor :math:`1+g`; with
a small probability :math:`p`, :math:`Y_{t}` grows by the factor :math:`\left(1+g\right)\left(1-b\right)`.
Thus the expected growth rate of :math:`Y_{t}` in each period is :math:`g^{*}\approx g-pb.`
Denote agent :math:`i`'s holding of the tree as :math:`K_{it}`. The supply of
the Lucas tree is normalized to one, and denote its price as :math:`P_{t}`.
The gross return of holding equity is :math:`R_{t}^{e}=\frac{Y_{t}+P_{t}}{P_{t-1}}`.
Agents also trade a risk-free bond, :math:`B_{it}`, whose net supply is
zero, and the gross interest rate is :math:`R_{t}^{f}`.

Denote the beginning-of-period wealth of agent :math:`i` by :math:`A_{it}`.
Each agent's budget constraint is 

.. math::
    C_{it}+P_{t}K_{it}+B_{it}=A_{it}.

Considering the type shifting shock, the law of motion of :math:`A_{it}`
is 

.. math::
    A_{it}=\left(Y_{t}+P_{t}\right)\left[K_{it-1}-\upsilon\left(K_{it-1}-\mu_{i}\right)\right]+\left(1-\upsilon\right)R_{t}^{f}B_{it-1}.


We can normalize the utility :math:`U_{it}` and consumption :math:`C_{it}` by
:math:`A_{it}` and write equation \eqref{eq:utility SafeAssets} as follows:

.. math::
    u_{it}^{1-\theta}=\frac{\rho+\upsilon}{1+\rho}c_{i,t}^{1-\theta}+\frac{1-\upsilon}{1+\rho}\left(1-c_{it}\right)^{1-\theta}\left(\mathbb{E}_{t}\left[\left(R_{i,t+1}u_{it+1}\right)^{1-\gamma_{i}}\right]\right)^{\frac{1-\theta}{1-\gamma_{i}}},
    :label: eq_normalized_utility_SafeAssets

in which :math:`u_{it}=U_{it}/A_{it}`, :math:`c_{it}=C_{it}/A_{it}`, and 

.. math::
    R_{i,t+1}=x_{it}R_{t+1}^{e}+\left(1-x_{it}\right)R_{t+1}^{f}

is the average return of agent :math:`i`'s portfolio, and


.. math::
    x_{it}=\frac{P_{t}K_{it}}{P_{t}K_{it}+B_{it}}

is the equity share of agent :math:`i`'s portfolio holding. The FOCs for
consumption and portfolio choices are 

.. math::
    \left(\rho+\upsilon\right)c_{i,t}^{-\theta}=\left(1-\upsilon\right)\left(1-c_{it}\right)^{-\theta}\left[\mathbb{E}_{t}\left(R_{i,t+1}u_{it+1}\right)^{1-\gamma_{i}}\right]^{\frac{1-\theta}{1-\gamma_{i}}},
    :label: eq_Euler_equation_SafeAssets

and 

.. math::
    \mathbb{E}_{t}\left[\frac{\left(R_{t+1}^{e}-R_{t+1}^{f}\right)u_{it+1}}{\left(R_{i,t+1}u_{it+1}\right)^{\gamma_{i}}}\right]=0.
    :label: eq_FOC_portfolio_choice

The choice of :math:`c_{it}` and :math:`x_{it}` are identical across agents
of the same type :math:`i`, and the portfolio choices of agent :math:`i` is

.. math:: 
    K_{it} & =x_{it}\left(1-c_{it}\right)\left(1+p_{t}\right)/p_{t}\omega_{it},\\
    b_{it} & =\left(1-x_{it}\right)\left(1-c_{it}\right)\left(1+p_{t}\right)\omega_{it}.

In equilibrium, prices are determined such that markets clear: 

.. math::
    C_{1t}+C_{2t}  =Y_{t},
    :label: eq_MC_goods


.. math::
    K_{1t}+K_{2t}  =1,
    :label: eq_MC_equity 


.. math::
    B_{1t}+B_{2t}  =0.
    :label: eq_MC_bond

To achieve stationarity, we normalize :math:`\left\{ B_{it},P_{t}\right\}` variables
by :math:`Y_{t}`. We define the wealth share of agent :math:`i` as 

.. math::
    \omega_{it}=K_{it-1}-\upsilon\left(K_{it-1}-\mu_{i}\right)+\frac{\left(1-\upsilon\right)R_{t}^{f}b_{it-1}}{\left(1+p_{t}\right)\left(1+g_{t}\right)}.
    :label: eq_consistency_SafeAssets

We see that given the market clearing conditions :eq:`eq_MC_equity`
and :eq:`eq_MC_bond`, 

.. math::
    \omega_{1t}+\omega_{2t}=1,\:\forall t.

For much of the analysis in `Barro et al. (2017) <https://www.nber.org/papers/w20652>`_, the intertemporal
elasticity of substitution :math:`theta` is set at :math:`1`. In this case,
agents consume a constant share of their wealth, and equation :eq:`eq_Euler_equation_SafeAssets`
is replaced by 

.. math::
    c_{it}=\frac{\rho+\upsilon}{1+\rho}.

Using this relationship for :math:`i=1,2`, and use the market clearing
conditions :eq:`eq_MC_goods`, :eq:`eq_MC_equity` and :eq:`eq_MC_bond`,
we have 

.. math::
    p_{t}=\frac{1-\upsilon}{\rho+\upsilon}.

The utility function :eq:`eq_normalized_utility_SafeAssets` is
replaced by 

.. math::
    \ln u_{it}= & \frac{\rho+\upsilon}{1+\rho}\ln c_{it}+\frac{1-\upsilon}{1+\rho}\ln\left(1-c_{it}\right)\label{eq:normalized log utility SafeAssets}\\
    & +\frac{1-\upsilon}{1+\rho}\frac{1}{1-\gamma_{i}}\ln\left[\mathbb{E}_{t}\left(R_{i,t+1}u_{it+1}\right)^{1-\gamma_{i}}\right].

The state variable is :math:`\omega_{1t}`. The unknowns are :math:`\left\{ x_{1t},x_{2t},R_{t}^{f},\omega_{it+1}\left(z_{t+1}\right)\right\}`.
We have 4 equations: :eq:`eq_FOC_portfolio_choice` for :math:`i=1,2`,
the market clearing condition for bond :eq:`eq_MC_bond` and the
consistency equation :eq:`eq_consistency_SafeAssets` to solve the
unknowns.

========================================
The mode File
========================================

The model is solved with the following :download:`safe_assets.gmod <safe_assets.gmod>` file

.. literalinclude:: safe_assets.gmod
    :linenos:
    :language: GDSGE

There is not too much new about the usage of the toolbox if you already came from examples :ref:`Heaton and Lucas (1996) <HL1996>` and Guvenen (2009).
There are some transformations worth mentioning which facilitate solving the model.

.. literalinclude:: safe_assets.gmod
    :lines: 71-75
    :lineno-start: 71
    :language: GDSGE

These lines describe how to calculate the Euler Equation residual

.. math::

    \mathbb{E}_{t}\left[\frac{\left(R_{t+1}^{e}-R_{t+1}^{f}\right)u_{it+1}}{\left(R_{i,t+1}u_{it+1}\right)^{\gamma_{i}}}\right]=0

when the CRRA coefficient :math:`\gamma_2` is very large: tracking and calculating the log level of utility instead of the level of utility.
This procedure proves to be essential in solving models with :math:`\gamma_2` very high, as :math:`u` can easily fall below 
the smallest number permitted by double precision.

Like previous examples, we can inspect the policy functions and ergodic sets after solving policy iterations and simulations. Here, we focus on
how to construct generalized impulse responses using the model simulations. Since the equilibrium concept involves an ergodic distribution of state, instead of a 
deterministic steady state. The proper concepts of impulse responses are sampling responses from ergodic sets, and take their averages and standard deviations.
The sampling procedure can be done on sub population of the ergodic set,  generating conditional impulse responses which will be of particular interests since 
the non-linear models may feature different dynamics starting from different part of the state space.

The procedures goes as follows: 

1. Simulate an ergodic set, which can be done by simulating one or multiple samples for long-period of time 
according to the Ergodic theorem. 

2. Replicate the ergodic set into two. For one of the two, turn the shock to "on" (the exact procedure depends on the model context,
for example, in the current example, "on" corresponds to the rare diaster state); for the other set, keep the shock unchanged.

3. Simulate the two sets, keeping the transitions of the exogenous shocks on. This procedure essentially captures the effect of the switching of the shock in the initial period
on subsequent dynamics. 

4. Calculate the mean and s.d. of the difference between simulated time series of the two sets. These arrive at the mean impulse responses and 
the standard deviations. Again, the above procedure can be conditional on a sub population of the ergodic set so as to compute 
conditional impulse responses starting from states with certain characteristics.

.. image:: figures/irf.png
    :scale: 40 %

The figure plots the impulse responses after
a one-time disaster using the baseline parameters in `Barro et al. (2017) <https://www.nber.org/papers/w20652>`_.
(For annual data, :math:`\rho=0.02`, :math:`\upsilon=0.02`, :math:`\mu=0.5`, :math:`\gamma_{1}=3.3`,
and :math:`\gamma_{2}=5.6`. Growth rate in normal times is :math:`0.025`. Rare
disaster happens with probability 4\%, and once it happens, productivity
drops by 32\%. The model period is one quarter.) As shown, the rare disaster shock redistributes
wealth from the less risk averse agent (Agent 1) to that of the more risk averse one (Agent 2). This leads to
more safe assets demanded compared, and a higher equilibrium quantity and price (lower interest rate) of the safe asset.

A final remark is on the price of safe assets, which exhibits non-monotonicity as the risk aversion level of Agent 2
:math:`\gamma_2`, as shown in the figure below.
This non-monotonicity usually overlooked and uncovered by our solution method that  solves models with high :math:`\gamma_2` robustly and accurately.

.. image:: figures/figure_Rf.png
    :scale: 50 %

The mechanism behind the non-monotonicity can be
understood by looking at two opposing forces. First, as :math:`\gamma_{2}`
gets larger, agent 2 becomes more risk-averse, and demand for more
of the safe asset (bond). This pushes down :math:`\bar{R}^{f}`. Second,
an increase in :math:`\gamma_{2}` also leads agent :math:`1` to borrow more
and become more leveraged. Since the return of equity is higher than
bond, the average wealth share of agent 1, :math:`\omega_{1}` becomes larger.
Larger :math:`\omega_{1}` leads to more relative supply of safe asset and
pushes up :math:`\bar{R}^{f}`. Whether :math:`\bar{R}^{f}` decreases or increases
in :math:`\gamma_{2}` depends on which force dominates. Figure below
shows that when :math:`\gamma_{2}` is below :math:`8` the first force dominates
and :math:`\bar{R}^{f}` is decreasing in :math:`\gamma_{2}` as assumed in `Barro et al. (2017) <https://www.nber.org/papers/w20652>`_.
However, when :math:`\gamma_{2}` is larger than :math:`8`, the second force
dominates and :math:`\bar{R}^{f}` is increasing in :math:`\gamma_{2}`. When
:math:`\gamma_{2}` is larger than 20, :math:`\bar{R}^{f}` is not responsive to
:math:`\gamma_{2}`, since the wealth distribution :math:`\omega_{1}` is almost
degenerated to its upper limit. See the figure below
as a comparison of two cases: :math:`\gamma_{2}=8` versus :math:`\gamma_{2}=10`.

.. image:: figures/dist_Rf.png
    :scale: 50 %


=====================
What's Next?
=====================

This example illustrates that the toolbox algorithm is especially effective to solve models where portfolio choices are sensitive to the asset price,
which are traditionally considered ill-behaved problems. In example Cao, Evans, and Luo (2020), we solve another model which is traditionally considered ill-behaved:
a two-country DSGE model with portfolio choices in which 
the returns to assets are close to collinear in certain region of the state space.

Or you can directly proceed to :ref:`Toolbox API`.

