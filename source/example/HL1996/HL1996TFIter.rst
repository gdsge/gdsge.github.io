******************************************************
Heaton and Lucas (1996): Transition Function Iteration
******************************************************

In the :ref:`Heaton and Lucas (1996) <Heaton and Lucas (1996): Incomplete Markets with Portfolio Choices>` example,
one of the challenges in solving the model
is the fact that the endogenous state variable, agents 1's wealth share (or consumption share), has an implicit law of motion.
We tackle this issue by including future values of the state variables among the unknown policy variables
to solve for in each iteration. We also include the *consistency equations* in the system of equilibrium conditions.
These equations require that future realizations of wealth share are consistent with current portfolio choices 
and future realizations of stock price, dividend, and aggregate growth rate:

.. math::
    \omega_{t+1}^{1}=\frac{(\hat{p}_{t+1}^{s}+\hat{d}_{t+1})s_{t+1}^{1}+\frac{\hat{b}_{t+1}^{1}}{\gamma^a_{t+1}}}{\hat{p}_{t+1}^{s}+\hat{d}_{t+1}}.


An alternative approach to the implicit law of motion is, in each policy function iteration, to conjecture 
a transition function for the endogenous state variable and use it to forecast future policy variables (consumption, stock price, etc.).
These forecasts can then be used to solve for current policy variables using the same system of equilibrium conditions (excluding the consistency equations).
The solution of the current policy variables can also be used to update the conjectured transition function for the next policy function iteration.
In a way, the approach iterates over both policy and transition functions. 
Therefore, to differentiate from the standard policy function iteration, we call this method transition function iteration.

There are two advantages of this alternative approach compared to our main policy function iteration approach 
with consistency equations.
First, there are a fewer equations to be solved in each iteration.
Second, the forecast future policy functions can be computed at the beginning of each iteration, 
independent of equation solving during the iteration.
A potential drawback is that the solution might not be as accurate because the consistency equations
might not be satisfied with high precision. However, one might start with this alternative to obtain
solution with reasonable accuracy quickly then switch back to the our main approach to achieve higher accuracy.


The alternative approach is used by 
`Vadim Elenev <https://www.vadimelenev.com>`_ (Johns Hopkins University), 
`Tim Landvoigt <https://sites.google.com/view/timlandvoigt>`_ (University Pensylvania),
and `Stijn Van Nieuwerburgh <https://www0.gsb.columbia.edu/faculty/svannieuwerburgh>`_ (Columbia University),
to solve `their model with richer empirical content <https://papers.ssrn.com/sol3/papers.cfm?abstract_id=2748230>`_, 
featuring both financial and non-financial sectors and a government. (The endogenous state variables with implicit laws of motion includes aggregate producers' leverage and aggregate banks' net-worth.)
The authors showed us that this approach can also be used to solve the model in `Heaton and Lucas (1996) <https://www.journals.uchicago.edu/doi/10.1086/262030>`_ 
with reasonable accuracy and have kindly contributed this example to this website.

Our GDSGE toolbox can implement this approach and its gmod file for `Heaton and Lucas (1996) <https://www.journals.uchicago.edu/doi/10.1086/262030>`_'s model is given below.
Notice that this approach requires some dampening in the update of policy and transition functions:

.. literalinclude:: HL1996TFIter.gmod
    :lines: 57-64
    :lineno-start: 57
    :language: GDSGE

As noted above, over the iterations, the consistency equations are not required to be satisfied. 
Therefore, once the algorithm converges for policy functions, 
one can switch back to the original gmod file in 
:ref:`Heaton and Lucas (1996) <Heaton and Lucas (1996): Incomplete Markets with Portfolio Choices>` with 
the consistency equations in order to make sure that these equations are satisfied with higher precision.

===============
The gmod File
===============

:download:`HL1996TFIter.gmod <HL1996TFIter.gmod>`

.. literalinclude:: HL1996TFIter.gmod
    :linenos:
    :language: GDSGE