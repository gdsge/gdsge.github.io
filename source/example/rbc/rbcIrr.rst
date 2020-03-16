****************************************
A RBC Model with Irreversible Investment
****************************************

The standard :ref:`RBC model <Getting Started - A Simple RBC Model>` can also be solved easily using local methods. Now we consider an exentsion which can only be solved properly using global methods. The model features an investment irreversibily constraint, which requires investment to be larger than a certain threshold.

===============
The Model
===============

We augment the simple RBC model with two additional features.

First, productivity follows a continuous AR(1) process

.. math::
    \log z_t = \rho \log z_{t-1} + \epsilon_t
    
where parameter :math:`\rho \in (0,1)` is the persistence, :math:`\epsilon_t` is an I.I.D. shock that takes on one of the two values :math:`-e` or :math:`+e` with equal probabilities.
    
Second, when accumulating capital,

.. math::
    K_{t+1} = K_t(1-\delta) + I_t,

the reprentative firm is subject to an irreversibility constraint

.. math::
    I_t \geq \phi I_{ss},

where :math:`I_{ss}` is the steady-state level of investment and parameter :math:`\phi` corresponds to the tightness of the irreversibility constraint.

These features require us to keep track of two continuous state variable: exogenous :math:`z_t` and endogenous :math:`K_t`. The toolbox is well designed to handle models with more than one continuous state variables like the present model.

Let :math:`\mu_t` denote the Lagrange multiplier on the irreversibility constraint, the complete-markets equilibrium can be characterized by the Euler equation, the complementary-slackness condition, and the goods market clearing condition

.. math::
    &c_t^{-\sigma}-\mu_t\\
    &=\beta \mathbb{E}_t \left[\left ( \alpha z_{t+1} K_{t+1}^{\alpha-1}+(1-\delta)\right)c_{t+1}^{-\sigma}-(1-\delta)\mu_{t+1}\right],\\
    &\\
    &\mu_t (K_{t+1}-(1-\delta)K_t-\phi I_{ss}) = 0,\\
    &\\
    &c_t+K_{t+1} = z_t K_t^{\alpha}+(1-\delta)K_t.





A recursive competitive equilibrium are functions: :math:`c(z,K), K'(z,K), \mu(z,K)` s.t.

.. math::
    &c(z,K)^{-\sigma}-\mu(z,K)\\
    &=\beta \mathbb{E}\left[ \left (\alpha z' [K'(z,K)]^{\alpha-1}+(1-\delta)\right)[c(z',K'(z,K))]^{-\sigma}-(1-\delta)\mu(z',K'(z,K)) \Big| z \right]\\
    &\\
    &\mu(z,K)(K'(z,K)-(1-\delta)K-\phi I_{ss})=0\\
    &\\
    &c(z,K)+K'(z,K)=zK^{\alpha} + (1-\delta)K.

This recursive system can be solved using a time iteration procedure similar to the one for the standard RCB model:

.. math::
    &c_t(z,K)^{-\sigma}-\mu_t(z,K)\\
    &=\beta \mathbb{E}\left[ \left (\alpha z' [K_t'(z,K)]^{\alpha-1}+(1-\delta)\right)[c_{t+1}(z',K_t'(z,K))]^{-\sigma}-(1-\delta)\mu_{t+1}(z',K_t'(z,K))\Big| z \right]\\
    &\\
    &\mu_t(z,K)(K'_t(z,K)-(1-\delta)K-\phi I_{ss})=0\\
    &\\
    &c_t(z,K)+K'_t(z,K)=zK^{\alpha} + (1-\delta)K.

taking functions :math:`c_{t+1}(z,K),\mu_{t+1}(z,K)` as known in the period-:math:`t` time step.

===============
The gmod File
===============

The recursive system can now be input to the GDSGE toolbox via a mod file :download:`rbcIrr.gmod <rbcIrr.gmod>` below.

.. literalinclude:: rbcIrr.gmod
    :linenos:
    :language: GDSGE

The toolbox solves the model and produce the policy functions. The following figure displays the investment policy function :math:`I(z,K)`. The investment irreversibility constraint tend to bind when :math:`K` is low or :math:`z` is low.  
    
.. image:: figuresIrr/policy_Inv.png
    :scale: 20 %

We then use the policy functions to simulate the model. The following figures show the long run distribution of investment and capital. The investment irrevrsibility constraint binds around 20% of the times. The distribution of capital is asymmetric and skewed towards lower levels of capital. It is significantly different from the distribution in the :ref:`RBC model <Getting Started - A Simple RBC Model>` without the irreversitiliby constraint.

.. image:: figuresIrr/histogram_Inv.png
    :scale: 40 %
    
.. image:: figuresIrr/histogram_K.png
    :scale: 40 %