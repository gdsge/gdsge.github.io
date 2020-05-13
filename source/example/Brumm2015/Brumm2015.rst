*********************************************************
Brumm et al (2015): A GDSGE model with asset price bubble
*********************************************************

`Brumm, Grill, Kubler, and Schmedders (2015) <https://onlinelibrary.wiley.com/doi/abs/10.1111/iere.12092>`_ 
study a GDSGE model with multiple assets with different degrees of collateralizability. 
They find that a long-lived asset which never pays dividend but can be used as collateral to borrow can have positive price in equilibrium.
From the traditional asset-pricing point of view, this positive price is a bubble because the present discounted value of dividend from the asset is exactly zero.

The model is similar to the ones in :ref:`Heaton and Lucas (1996) <Heaton and Lucas (1996): Incomplete Markets with Portfolio Choices>` and :ref:`Cao (2018) <Cao (2018): Speculation and Wealth Distribution under Beliefs Heterogeneity>`.
It features two representative agents :math:`h\in\{1,2\}` who have Epstein-Zin utility with the same intertemporal elasticity of substitution and different coefficients of risk-aversion:

.. math::

    U_{h,t}=\left\{\left[c_{h,t}\right]^{\rho^h}+\beta\left[\mathbb{E}_{t}\left(U_{h,t+1}^{\alpha^h}\right)\right]^{\frac{\rho^h}{\alpha^h}}\right\}^{\frac{1}{\rho^h}}.

The agents can trade in shares of two long-lived assets (Lucas' trees), :math:`i\in\{1,2\}` and a risk-free bond. 


In period :math:`t` (we suppress the explicit dependence on shock history :math:`z^t` to simplify the notation), asset :math:`i` pays dividend :math:`d_{i,t}` worth a fraction :math:`\sigma_i` of aggregate output and traded at price :math:`q_{i,t}`.
The agents cannot short sell the long-lived asset but they can short sell the risk-free bond, i.e., borrow. In order to borrow in the risk-free bond, the agents must use the assets as collateral. The agents can pledge a fraction :math:`\delta_i` of the value of their asset :math:`i` holding as collateral.
In particular, the colateral constraint takes the form:

.. math::

    \phi^h_{t+1}+\sum_{i\in\{1,2\}}\theta^h_{i,t+1}\delta_i\min_{z^{t+1}|z^t}(q_{i,t+1}+d_{i,t+1})\geq0,

where :math:`\phi^h,\theta^h_1,\theta^h_2` denote the bond holding, and asset :math:`1` and asset :math:`2` holdings of agents :math:`h`. 

This model can be written and solved using our toolbox. This is done by `Hewei Shen <https://sites.google.com/site/heweiecon/>`_ from the University of Oklahoma, who generously contributed the GDSE code below.
Hewei's own research demonstrates the importance of GDSGE models in studying macro-prudential and fiscal policies in emerging market economies, 
such as his `recent publication <https://www.sciencedirect.com/science/article/pii/S1094202518302515?via%3Dihub>`_ 
and his `ongoing work <https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3165726>`_. 

Notice that in the GDSGE code, asset :math:`1` never pays dividend, i.e., :math:`\sigma_1 = 0`.
Therefore, in finite-horizon economies, by backward induction, its price is always equal to :math:`0`.
In order for the sequence of finite-horizon equilibria to converge to an infinite-horizon equilibrium in which asset :math:`1` has positive price,
we need to assume that agents derive utility from holding the asset in the very last period in each T-period economy:

.. math::
    U_{h,T} = \left[c_{h,T}\right]^{\rho^h}+\zeta \left[\theta^h_{1,T}\right]^{\rho^h}.

This assumption is a purely numerical device and becomes immaterial when :math:`T\rightarrow\infty`.
To solve the last period problem, we use a *model_init* block that has a different system of equations
than that of the main *model* block (see example :ref:`Cao and Nie (2017) <CaoNie2017>` 
for another example using a different *model_init*).

.. _BGKS2015:
===============
The gmod File
===============

:download:`BGKS2015.gmod <BGKS2015.gmod>`

.. literalinclude:: BGKS2015.gmod
    :linenos:
    :language: GDSGE

==================
Results
==================

In this example, agents :math:`1` (:math:`\alpha_1 = 0.5`) are less risk-averse than agents :math:`2` (:math:`\alpha_2 = -6`) 
so they tend to borrow to invest in the risky assets :math:`1` and :math:`2`. 
Asset :math:`1` nevers pays dividend (:math:`\sigma_1=0`) but can be used as collateral to borrow (:math:`\delta_1 = 1`).
While asset :math:`2` pays dividend (:math:`\sigma_2>0`) but cannot be used as collateral (:math:`\delta_2=0`).
In equilibrium, asset :math:`1` still commands a positive price. Therefore, this is an asset price bubble arising from collateralizibity.
The following figure shows the price of asset :math:`1` relative to aggregate output as a function of agents :math:`1`'s wealth share

.. math::
    \omega^1_t = \frac{\theta^1_{1,t}(q_{1,t}+d_{1,t})+\theta^1_{2,t}(q_{2,t}+d_{2,t})+\phi^1_t}{q_{1,t}+d_{1,t}+q_{2,t}+d_{2,t}}.

The price of asset :math:`1` be as high as several times aggregate output and tends to be higher when agents :math:`1` are relatively richer.

.. image:: figures/BGKS2015Bubble.png
    :scale: 100 %

