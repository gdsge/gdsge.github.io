*****************************************************************
Mendoza (2010): Sudden Stops with Asset Price Deflation
*****************************************************************

`Mendoza (2010) <https://www.aeaweb.org/articles?id=10.1257/aer.100.5.1941>`_  studies an open economy model with
a borrowing constraint tied to the capital price. A negative shock that lowers the capital price 
tightens the collateral constraint, leading to deleveraging and reductions in financing for both investment and working capital, so the effect of the shock gets amplified.
The model generates financial crises with current account reversals resembling those experienced by many emerging economies.
The collateral constraints are occasionally binding in the ergodic set.
The equilibrium policy and state transition functions are highly nonlinear. The model has two endogenous states, capital and bond, and can be solved
using the toolbox very easily (in 200 lines of GDSGE code and within a minute on a regular laptop).

Though the model can be directly solved over the natural state space (capital, bond) using the toolbox, practically it is sometimes difficult
to determine the feasible state space over which an equilibrium exists. For example,  in the current context, given capital stock, an economy too much in debt
may not be able to find feasible allocations. This suggests that the lower bound of bond depends on the capital stock
and the feasible state space is not a simple box. We demonstrate how such a model can solved with state transformation and implicit
state transition functions, without the hassle of determining the feasible endogeneous state space ex-ante.

.. _Mendoza2010:
===============
The Model
===============

There is a single consumption good. The inter-temporal expected utility is given by

.. math::

    \mathbb E_{0}
    \sum_{t=0}^{\infty}  \beta^t[ u\left(c_{t}-N\left(L_{t}\right)\right)]

where :math:`\beta` is the discount factor, :math:`c_t` is consumption, :math:`L_t` is labor supply. :math:`u(\cdot)` is the utility function.

The production function is

.. math::

    A_tF(k_t,L_t,v_t),

where :math:`A_t` is productivity which follows an exogenous Markov process. :math:`F` is a constant-return-to-scale production function. :math:`k_t` is capital, :math:`L_t` is labor, and :math:`v_t` is intermediate goods used.

:math:`\phi` fraction of the cost of hiring :math:`L_t` and :math:`v_t` needs to be financed externally, at a (world) gross interest rate :math:`R_t` that follows an exogenous process. 
The economy can trade a state non-contingent bond :math:`b_{t+1}` (who negative values imply borrowing) with the world, but borrowing is subject to the following constraint

.. math::

    q_{t}^{b} b_{t+1}-\phi R_{t}\left(w_{t} L_{t}+p_{t} v_{t}\right) \geq-\kappa q_{t} k_{t+1},

which says that the borrowing plus the finance for working capital cannot exceed :math:`\kappa` fraction of the value of the next period capital :math:`k_{t+1}`, 
where :math:`p_t` is intermediate goods price following an exogenous process, 
:math:`w_t` is wage and :math:`q_t` is the endogenous asset price of the next period capital determined below. 
It should be clear that the binding collateral constraint will affect the financing of working capital.

Investment is subject to a convex adjustment cost

.. math::

    i_{t}=k_{t+1} - (1-\delta)k_t+\frac{1}{2} a \frac{(k_{t+1}-k_t)^{2}}{k_t},

where :math:`a` is a parameter determining the level of adjustment cost. The next period capital price is competitively determined as 

.. math::

    q_t=\frac{\partial i_t}{\partial k_{t+1}}=1+a\frac{k_{t+1}-k_t}{k_t}.

We also write down the shadow price of current capital

.. math::

    q_t+d_t & \equiv A_tF_1(k_t,L_t,v_t)-\frac{\partial i_t}{\partial k_{t}}\\
    &=A_tF_1(k_t,L_t,v_t)-  (1-\delta) -a\frac{k_{t+1}-k_t}{k_t}- \frac{a}{2}\frac{(k_{t+1}-k_t)^{2}}{k_t^2}. 


Under the competitive equilibrium, the agent maximizes the inter-temporal expected utility subject to

.. math::

    (1+\tau)c_{t}+i_{t}=A_t F\left(k_{t}, L_{t}, v_{t}\right)-p_{t} v_{t}-\phi\left(R_{t}-1\right)\left(w_{t} L_{t}+p_{t} v_{t}\right)-q_{t}^{b} b_{t+1}+b_{t},
    \\
    q_{t}^{b} b_{t+1}-\phi R_{t}\left(w_{t} L_{t}+p_{t} v_{t}\right) \geq-\kappa q_{t} k_{t+1},
    \\
    i_{t}=k_{t+1} - (1-\delta)k_t+\frac{1}{2} a^2 \frac{(k_{t+1}-k_t)^{2}}{k_t},

taking exogenous processes :math:`A_t,R_t,p_t` and :math:`q_t^b(=1/R_t)`, and equilibrium prices :math:`w_t` and :math:`q_t` as given. Denote :math:`\lambda_t` as the multiplier for the budget constraint and :math:`\mu_t` as the multiplier for the collateral constraint, the first order conditions and complementarity slackness conditions read:

.. math::

    & \{b_{t+1}\}:
    -q_t^b\lambda_t+\mu_tq_t^b+\beta \mathbb{E}_t \lambda_{t+1}=0
    \\
    & \{k_{t+1}\}: \beta \mathbb{E}_t \lambda_{t+1}A_{t+1}F_1(k_{t+1},L_{t+1},v_{t+1}) - \beta \mathbb{E}_t\lambda_{t+1} \frac{\partial i_{t+1}}{\partial k_{t+1}} - \lambda_t q_t +\mu_t \kappa q_t=0
    \\
    & \{\mu_t\}: [q_{t}^{b} b_{t+1}-\phi R_{t}\left(w_{t} L_{t}+p_{t} v_{t}\right) +\kappa q_{t} k_{t+1}]{\mu}_t=0
    \\
    & \{L_t\}: A_{t}F_2(k_t,L_t,v_t)=w_t (1+\phi(R_t-1)+\frac{\mu_t}{\lambda_t} \phi R_t); \ w_t=N'(L_{t})(1+\tau) 
    \\
    & \{v_t\}: A_{t}F_3(k_t,L_t,v_t)=p_{t}(1+\phi(R_t-1)+\frac{\mu_t}{\lambda_t} \phi R_t)
    \\
    & \{c_t\}: u'(c_t-N(L_t)) = \lambda_t(1+\tau) 

The exogenous states are :math:`z=(A,R,p)`. The natural endogenous states are :math:`(k,b)`. A recursive equilibrium  is functions :math:`b'(z,k,b), k',\mu,L,v,c,\lambda,q,w` that satisfy the above equations. The system can be further simplified. Before doing so, we introduce the state transformation to ensure the 
feasible state space is square.

==========================
State Space Transformation
==========================
If the economy is too indebted, it may never be able to finance positive consumption subject to the current collateral constraint, and the equilibrium does not exist. 
Therefore, the lower bound of the bond holding of the feasible state space depends on the exogenous shocks and capital, rendering the feasible state space non-rectangle. 
This non-rectangle state space also cannot be determined ex-ante, since the collateral constraint depends on the endogenous capital price. 
This is a well-known challenge encountered by many researchers studying models with a borrowing constraint tied to an asset price. 
The challenge can be solved by noticing the exact boundary condition of the initial problem: 
the boundary of the feasible state space is such that consumption (more precisely, the GHH consumption-labor bundle) is zero.
Therefore, if we transform the state space to consumption and capital, then the feasible state space will be a simple rectangle.

Define the GHH consumption-labor bundle as

.. math::

    \tilde{c}_t \equiv c_t-N(L_t).

With such state transformation, we write down the minimum recursive system that represents the equilibrium. A recursive equilibrium is functions :math:`k'(z,\tilde{c},k)`,
:math:`b'(z,\tilde{c},k)`, :math:`L(z,\tilde{c},k)`, :math:`v(z,\tilde{c},k)`,
:math:`\mu(z,\tilde{c},k)`, :math:`\tilde{c}'(z';z,\tilde{c},k)` such that (omitting the dependence on :math:`(z,\tilde{c},k)` when there is no confusion)

.. math::

    & -q^b\lambda+\mu q^b+\beta \mathbb{E} [\lambda'(z',\tilde{c}'(z'),k')|z]=0
    \\
    & \beta \mathbb{E}[ \lambda'(z',\tilde{c}'(z'),k')\{d'(z',\tilde{c}'(z'),k')+q'(z',\tilde{c}'(z'),k')\}|z ]- \lambda q +\mu \kappa q=0
    \\
    & AF_2(k,L,v)=w (1+\phi(R-1)+\frac{\mu}{\lambda} \phi R)
    \\
    & AF_3(k,L,v)=p(1+\phi(R-1)+\frac{\mu}{\lambda} \phi R)
    \\
    & (1+\tau)\tilde{c}'(z')=B'(z',\tilde{c}'(z'),k') +b', \forall z'

where :math:`\lambda,w,q,\lambda'` are intermediate variables and can be evaluated according to

.. math::

    & \lambda = u'(\tilde{c})
    \\
    & w= N'(L)
    \\
    & q=1+a\frac{k'-k}{k}
    \\
    & \lambda'= u'(\tilde{c}'(z'))

The last equation :math:`(1+\tau)\tilde{c}'(z')=B'(z',\tilde{c}'(z'),k')  +  b'` specifies the consistency equation for :math:`\tilde{c}_{t+1}`, which is simply the period-:math:`(t+1)` budget constraint:

.. math::
    (1+\tau)\underbrace{[c_{t+1}-N(L_{t+1})]}_{\tilde{c}_{t+1}}=B_{t+1} + b_t,
where

.. math::
    B_{t+1}&=&A_{t+1} F\left(k_{t+1}, L_{t+1}, v_{t+1}\right)-p_{t+1} v_{t+1}-\phi\left(R_{t+1}-1\right)\left(w_{t+1} L_{t+1}+p_{t+1} v_{t+1}\right)\\
    &&-q_{t+1}^{b} b_{t+2}-i_{t+1}-(1+\tau)N(L_{t+1}).

Notice, how the budget constraint is decreased by :math:`(1+\tau)N(L_{t+1})` so that this becomes a consistency equation for :math:`\tilde{c}_{t+1}`.

The recursive system is solved by taking :math:`d'(z,\tilde{c},k),q'(z,\tilde{c},k),B'(z,\tilde{c},k)` as known at each time iteration step, and updating
these objects following their definitions.

========================
The gmod File
========================

We use the exact specification and parameterization as in `Mendoza (2010) <https://www.aeaweb.org/articles?id=10.1257/aer.100.5.1941>`_. 
In particular, for preference

.. math::

    u(c) = \frac{c^{1-\sigma}}{1-\sigma}

.. math::

    N(L) = L^{\omega}/\omega.

The production function is Cobb-Douglas:

.. math::

    F(k,L,v) = k^{\gamma}L^{\alpha}v^{\eta}.
    

For parameters, see the gmod file (:download:`mendoza2010 <mendoza2010.gmod>`) listed below

.. literalinclude:: mendoza2010.gmod
    :linenos:
    :language: GDSGE

Most of the gmod codes are straightforward and should be self-explanatory. We do want to highlight that the state transformation and implicit state transition 
are implemented by including :math:`\tilde{c}'(z')` as unknowns in Line 97

.. literalinclude:: mendoza2010.gmod
    :lines: 97-97
    :lineno-start: 97
    :language: GDSGE

defining the consistency equations in Line 136

.. literalinclude:: mendoza2010.gmod
    :lines: 136-136
    :lineno-start: 136
    :language: GDSGE

and including them in the system of equations in Line 156

.. literalinclude:: mendoza2010.gmod
    :lines: 156-156
    :lineno-start: 156
    :language: GDSGE

We also discuss the necessary transformation when solving the system of equations with potentially non-box constraints
(i.e., the collateral constraint which specifies that borrowing cannot exceed a fraction of the value of capital that depends on the endogenous capital price).
This should be familiar if readers already came from the :ref:`Bianchi (2011) <Bianchi2011>` or :ref:`Heaton and Lucas (1996) <HL1996>` examples.
This is done by defining a variable and including it as unknown

.. math::
    
    nb_{t+1}=q_{t}^{b} b_{t+1}-\phi R_{t}\left(w_{t} L_{t}+p_{t} v_{t}\right) +\kappa q_{t} k_{t+1}

so the collateral constraint becomes :math:`nb_{t+1} \geq 0`. And transform :math:`nb_{t+1}` back to :math:`b_{t+1}` in Line

.. literalinclude:: mendoza2010.gmod
    :lines: 125-125
    :lineno-start: 125
    :language: GDSGE

Another transformation to ensure numerical stability is to normalize each of the equations in the system so they take value in similar scales
(the equation solver handles this automatically to some extent but researchers can do better with prior information).
For example, the Euler equation for bond is written as 

.. math::

    -1 +\mu_t / \lambda_t +\beta \mathbb{E}_t \lambda_{t+1} / (\lambda_t q_t^b) = 0

so the equation takes value between [0,1]. Accordingly, we have defined the multiplier for the collateral constraint to be normalized by the marginal utility 
:math:`\hat{\mu}_t=\mu_t/\lambda_t` (:math:`\mu` in the code actually corresponds to 
:math:`\hat{\mu}`), so from the bond Euler equation we know :math:`\hat{\mu}` must lie in [0,1], which is specified as the bound for :math:`\mu` entering the equation solver.
These procedures are not necessary but are simple and effective ways to solve the system faster and more accurately.


Now let's run the policy iterations by calling *iter_mendoza2010.m* returned from a local or remote GDSGE compiler, which produces output

.. code-block:: MATLAB

    >> IterRslt = iter_mendoza2010;
    Iter:10, Metric:0.00819545, maxF:3.83276e-09
    Elapsed time is 5.885684 seconds.
    Iter:20, Metric:0.00329338, maxF:1.72695e-09
    Elapsed time is 2.855950 seconds.
    Iter:30, Metric:0.00139174, maxF:1.72276e-09
    Elapsed time is 2.474352 seconds.

    ...

    Iter:117, Metric:9.38205e-07, maxF:1.53505e-09
    Elapsed time is 1.252342 seconds.

Notice so far, relatively crude grids for the state space are specified in the gmod file. 
We can refine the solution on finer grids starting from a previously converged solutions, by simply
specifying the converged solution as a *WarmUp*. Here we enlarge the state space to have 80 grid points along both :math:`\tilde{c}` and :math:`k` space, 
increasing the number of (exogenous and endogenous) states
to :math:`8\times 80\times 80 = 51200`.

.. code-block:: MATLAB

    >> options = struct;
    cTilde_pts_fine = 80;
    options.cTilde = linspace(IterRslt.var_state.cTilde(1),IterRslt.var_state.cTilde(end),...
        cTilde_pts_fine);
    k_pts_fine = 80;
    options.k = linspace(IterRslt.var_state.k(1),IterRslt.var_state.k(end),k_pts_fine);
    options.WarmUp = IterRslt;
    IterRslt = iter_mendoza2010(options);
    
    Iter:120, Metric:0.0018683, maxF:8.3636e-09
    Elapsed time is 6.149458 seconds.
    Iter:130, Metric:6.52679e-05, maxF:8.48362e-09
    Elapsed time is 16.472054 seconds.
    Iter:140, Metric:1.57918e-05, maxF:8.50322e-09
    Elapsed time is 13.596291 seconds.
    Iter:150, Metric:4.02934e-06, maxF:8.41073e-09
    Elapsed time is 12.792310 seconds.
    Iter:160, Metric:1.08769e-06, maxF:7.73757e-09
    Elapsed time is 11.707143 seconds.
    Iter:161, Metric:9.56593e-07, maxF:7.234e-09
    Elapsed time is 1.134286 seconds.

The refined iterations continue to converge in another minute. It's always a good convention to start with some cruder grid to assess the properties 
(such as the range of the ergodic set)
of the solution of a model,
and refine it using the crude solution as a WarmUp.

Now we inspect the policy functions. We first come back to our motivation for state space transformation: the natural state space
:math:`(k,b)` is non-rectangle. This can be verified by projecting the state variable :math:`\tilde{c}` onto policy :math:`b` and state variable :math:`k`.

.. code-block:: MATLAB

    >> figure;
    [cTilde_mesh,k_mesh] = ndgrid(IterRslt.var_state.cTilde,IterRslt.var_state.k);
    surf(squeeze(IterRslt.var_aux.b(1,:,:)),k_mesh,cTilde_mesh);
    xlabel('b');
    ylabel('k');
    title('Feasible Region of Shock Index 1');
    view(-0.06,90);

.. image:: figures/policy_cTilde_feasible.png
    :scale: 60 %

As shown in the figure, the level of bond that gives a same lower bound of consumption (here :math:`\tilde{c}` equal to 100) is declining in capital, suggesting that a higher capital allows
the current debt to be higher. However, determining this lower bound of bond level is difficult; but determining the boundary condition for consumption is much easier
(:math:`\tilde{c}=0`). 

We can inspect the policy functions by projecting them to the natural state space as well. For example, the capital price:

.. code-block:: MATLAB

    >> figure;
    [cTilde_mesh,k_mesh] = ndgrid(IterRslt.var_state.cTilde,IterRslt.var_state.k);
    surf(squeeze(IterRslt.var_aux.b(1,:,:)),k_mesh,squeeze(IterRslt.var_aux.q(1,:,:)));
    xlabel('b');
    ylabel('k');
    title('Capital Price, Shock Index 1');

.. image:: figures/policy_q.png
    :scale: 60 %

And the multiplier (normalized by marginal utility) for collateral constraint:

.. code-block:: MATLAB

    >> figure;
    [cTilde_mesh,k_mesh] = ndgrid(IterRslt.var_state.cTilde,IterRslt.var_state.k);
    surf(squeeze(IterRslt.var_aux.b(1,:,:)),k_mesh,squeeze(IterRslt.var_policy.mu(1,:,:)));
    xlabel('b');
    ylabel('k');
    title('Multiplier for the Collateral Constraint, Shock Index 1');
    view(-16,26);

.. image:: figures/policy_mu.png
    :scale: 60 %

These two policy functions show that the collateral constraint tends to bind 
when bond is low (borrowing is high).
And capital price falls rapidly in borrowing when the collateral constraint binds.

With the converged policy and state transition functions, we can simulate the economy's ergodic set.
To remind readers, here we directly interpolate the state transition and policy functions to simulate, which is faster 
than resolving the system (the simulation with 
24 paths of 50,000 periods completes in less than half a minute on a regular laptop). This is done by specifying in the gmod file

.. literalinclude:: mendoza2010.gmod
    :lines: 22-22
    :lineno-start: 22
    :language: GDSGE

In this case, the variables to be recorded in the simulation need to be explicitly specified in *var_output*

.. literalinclude:: mendoza2010.gmod
    :lines: 107-107
    :lineno-start: 107
    :language: GDSGE

and can then be included in *var_simu*

.. literalinclude:: mendoza2010.gmod
    :lines: 167-167
    :lineno-start: 167
    :language: GDSGE

With implicit state transition functions for :math:`\tilde{c}` solved as part of the policy functions,
the transitions need to be specified in the simulate block

.. literalinclude:: mendoza2010.gmod
    :lines: 168-168
    :lineno-start: 168
    :language: GDSGE

which means that the next period *cTilde* should pick policy *cTildeNext* at a sampled exogenous shock index.

Calling simulate_mnendoza2010 produces the following

.. code-block:: MATLAB

    >> SimuRslt = simulate_mendoza2010(IterRslt);
    Periods: 1000
    shock  cTilde       k       c       Y       q     inv       b   bNext       v      nx     gdp   b_gdp  nx_gdp     lev  wkcptl
        1   166.9   747.1   282.5     429   1.048   78.98   109.7   86.46   43.32  -23.58   385.9  0.2843 -0.06110.0002417   76.13

    ...

    Periods: 50000
    shock  cTilde       k       c       Y       q     inv       b   bNext       v      nx     gdp   b_gdp  nx_gdp     lev  wkcptl
        5   149.8   741.1   262.8   423.8  0.9844   61.04  -33.48  -31.26   42.34   13.19   381.7-0.08769 0.03455 -0.1525    74.4


We can inspect the histogram of the natural state variables :math:`(k,b)` by calling in MATLAB:

.. code-block:: MATLAB

    >> figure;
    hist3([SimuRslt.b(:),reshape(SimuRslt.k(:,1:end-1),[],1)],[50,50],'CDataMode','auto','FaceColor','interp');
    view([15,30]);
    xlabel('Bond');
    ylabel('Capital');
    title('Histogram of Capital and Bond');
    print('figures/histogram_b_k.png');

.. image:: figures/histogram_b_k.png
    :scale: 60 %

We are interested in the fraction of time that the economy spends in a crisis, i.e., states with binding collateral constraint:

.. code-block:: MATLAB

    >> muGreaterThanZero = SimuRslt.mu > 1e-7;
    fractionCrisis = sum(muGreaterThanZero(:)) / numel(muGreaterThanZero(:));
    fprintf('The fraction in crisis: %g\n',fractionCrisis);
    The fraction in crisis: 0.131997

We can calculate the unconditional moments:

.. code-blocK:: MATLAB

    >> statsList = {'mean','std'};
    varList = {'gdp','c','inv','nx_gdp','k','b_gdp','q','lev','v','wkcptl'};
    ratioList = {'nx_gdp','b_gdp','lev'};
    meanStats = struct;
    stdStats = struct;
    corrStats = struct;
    autoCorrStats = struct;
    startPeriod = 1001;
    endPeriod = 50000;
    for i_var = 1:length(varList)
        varName = varList{i_var};
        meanStats.(varName) = mean(reshape(SimuRslt.(varName)(:,startPeriod:endPeriod),[],1));
        if max(strcmp(varName,ratioList))==1
            stdStats.(varName) = std(reshape(SimuRslt.(varName)(:,startPeriod:endPeriod),[],1));
        else
            stdStats.(varName) = std(reshape(SimuRslt.(varName)(:,startPeriod:endPeriod),[],1)) ...
                / meanStats.(varName);
        end
        corrStats.(varName) = corr(reshape(SimuRslt.(varName)(:,startPeriod:endPeriod),[],1), ...
            reshape(SimuRslt.gdp(:,startPeriod:endPeriod),[],1));
        autoCorrStats.(varName) = corr(reshape(SimuRslt.(varName)(1,startPeriod+1:endPeriod),[],1), ...
            reshape(SimuRslt.(varName)(1,startPeriod:endPeriod-1),[],1));
    end

.. csv-table:: Unconditional Business Cycle Moments
   :file: tables/all_stats_formatted.csv

Most statistics are similar to `Mendoza (2010) <https://www.aeaweb.org/articles?id=10.1257/aer.100.5.1941>`_ except that `Mendoza (2010) <https://www.aeaweb.org/articles?id=10.1257/aer.100.5.1941>`_ uses a Stationary Cardinal Utility (SCU) utility function and 
solves the model by solving a quasi social planner's problem which produces
(1) less persistent leverage and bond, and (2) higher leverage and more
negative bond/gdp ratio. These differences are also noted in `Mendoza and Villalvazo (2020) <https://www.sciencedirect.com/science/article/pii/S1094202520300028>`_.

=====================
What's Next?
=====================

This example illustrates how to solve a model with two endogenous state variables of which the exogenous feasible state space may be non-rectangle and hard to determine ex-ante.
The crucial step is to transform the boundary condition to that of an endogenous state variable which makes the state space a simple rectangle. In the current example, the 
feasible debt level is high so the model can be solved directly over the natural state space---bond and capital. Such transformation 
becomes essential for more complex problems, and sometimes the boundary condition needs to be solved using a different equilibrium system. The toolbox accommodates this 
by allowing a different system of equations for problems at the boundary. See :ref:`Cao and Nie (2017) <CaoNie2017>` for such an example, in which consumption is zero and the Inada condition is violated at the boundary.

The policy functions in the current example are highly nonlinear. We learned how to start with a crude grid and refine the solution with finer grids. A more effective approach
is to let the toolbox automatically adapt the grids to increase points in regions that are nonlinear.
The example in :ref:`Bianchi (2011) <Bianchi2011>` shows how to use adaptive grids for a model with a single-dimension endogenous state.
The current model can also be solved with adaptive grids by simply specifying one option in the gmod file, which we leave as an exercise.

Or you can directly proceed to :ref:`Toolbox API`.