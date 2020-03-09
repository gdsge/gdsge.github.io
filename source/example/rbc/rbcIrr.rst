*****************************************
An Extension with Irreversible Investment
*****************************************

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
    I_t \geq 0.
    
Let :math:`\mu_t` denote the Lagrange multiplier on the irreversibility constraint, the complete-markets equilibrium can be characterized by the Euler equation, the complementary-slackness condition, and the goods market clearing condition

.. math::
    &c_t^{-\sigma}-\mu_t=\beta \mathbb{E}_t \left[\left ( \alpha z_{t+1} K_{t+1}^{\alpha-1}+(1-\delta)\right)c_{t+1}^{-\sigma}-(1-\delta)\mu_{t+1}\right],\\
    &\mu_t (K_{t+1}-(1-\delta)K_t) = 0,\\
    &c_t+K_{t+1} = z_t K_t^{\alpha}+(1-\delta)K_t.





A recursive competitive equilibrium are functions: :math:`c(z,K), K'(z,K), \mu(z,K)` s.t.

.. math::
    &c(z,K)^{-\sigma}-\mu(z,K)=\beta \mathbb{E}\left[ \left (\alpha z' [K'(z,K)]^{\alpha-1}+(1-\delta)\right)[c(z',K'(z,K))]^{-\sigma}-(1-\delta)\mu(z',K'(z,K)) \Big| z \right]\\
    &\mu(z,K)(K'(z,K)-(1-\delta)K)=0\\
    &c(z,K)+K'(z,K)=zK^{\alpha} + (1-\delta)K.

This recursive system can be solved using a time iteration procedure similar to the one for the standard RCB model:

.. math::
    &c_t(z,K)^{-\sigma}-\mu_t(z,K)=\beta \mathbb{E}\left[ \left (\alpha z' [K_t'(z,K)]^{\alpha-1}+(1-\delta)\right)[c_{t+1}(z',K_t'(z,K))]^{-\sigma}-(1-\delta)\mu_{t+1}(z',K_t'(z,K))\Big| z \right]\\
    &\mu_t(z,K)(K'_t(z,K)-(1-\delta)K)=0\\
    &c_t(z,K)+K'_t(z,K)=zK^{\alpha} + (1-\delta)K.

taking functions :math:`c_{t+1}(z,K),\mu_{t+1}(z,K)` as known in the period-:math:`t` time step.

===============
The gmod File
===============

The recursive system can now be input to GDSGE via a mod file rbcIrr.gmod below.

.. literalinclude:: rbcIrr.gmod
    :linenos:
    :language: GDSGE

    
.. image:: figures/policy_c.png
    :scale: 50 %

We can now simulate the model by inputting IterRslt into simulate_rbc:

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

=====================
What's Next?
=====================

Now you understand the basic usage of the toolbox.
You can proceed to a real example Heaton and Lucas (1996) in the toolbox paper.

Or you can proceed to :ref:`Toolbox API`.