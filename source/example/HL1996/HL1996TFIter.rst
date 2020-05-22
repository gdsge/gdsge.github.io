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


An alternative approach to the implicit law of motion is, in each policy function iteration, to start from a conjectured transition function 
for the endogenous state variable and use it to forecast future policy variables (consumption, stock price, etc.).
These forecasts can then be used to solve for current policy variables using the same system of equilibrium conditions (excluding the consistency equations).
At the end of each iteration, the conjectured transition function is updated using the solution of the current policy variables.
In a way, the approach iterates over both policy and transition functions. 
Therefore, to differentiate from the standard policy function iteration, we call this method *transition function iteration*.

There are two advantages of this alternative approach compared to our main policy function iteration approach 
with consistency equations.
First, there are a fewer equations to be solved in each iteration.
Second, the forecasts for future policy variables can be computed at the beginning of each iteration, 
independent of equation solving during the iteration.
A potential drawback is that the solution might not be as accurate as the original method because the consistency equations
might not be satisfied with high precision. However, one might start with this alternative to obtain
solution with reasonable accuracy quickly then switch back to the our main approach to achieve higher accuracy.


The alternative approach is developed by 
`Vadim Elenev <https://www.vadimelenev.com>`_ (Johns Hopkins University), 
`Tim Landvoigt <https://sites.google.com/view/timlandvoigt>`_ (University Pennsylvania),
and `Stijn Van Nieuwerburgh <https://www0.gsb.columbia.edu/faculty/svannieuwerburgh>`_ (Columbia University),
to solve `their model with rich empirical content <https://papers.ssrn.com/sol3/papers.cfm?abstract_id=2748230>`_, 
featuring both financial and non-financial sectors and a government. (The endogenous state variables with implicit laws of motion include aggregate producers' leverage and aggregate banks' net-worth.)
The model captures salient features of macro-finance dynamics during the Great Recessions and 
has important implications on bank capital regulation.

The authors showed us that this approach can also be used to solve the model in `Heaton and Lucas (1996) <https://www.journals.uchicago.edu/doi/10.1086/262030>`_ 
with reasonable accuracy and have kindly contributed this example to this website. Our GDSGE toolbox can implement this approach and its gmod file for 
`Heaton and Lucas (1996) <https://www.journals.uchicago.edu/doi/10.1086/262030>`_'s model is given below.
We design two features of the toolbox, macros for loop and *pre-model* block, to 
faciliate the implementation of the approach and to make the most of its computation economizing property.
We discuss these features in more detail below.


Notice that this approach requires some dampening in the update of policy and transition functions:

.. literalinclude:: HL1996TFIter.gmod
    :lines: 57-64
    :lineno-start: 57
    :language: GDSGE

As also noted above, over the iterations, the consistency equations are not required to be satisfied
so they are excluded from the system of equilibrium conditions in the gmod file:

.. literalinclude:: HL1996TFIter.gmod
    :lines: 99-111
    :lineno-start: 99
    :language: GDSGE

Therefore, once the algorithm converges for policy functions, 
one can switch back to the original gmod file in 
:ref:`Heaton and Lucas (1996) <Heaton and Lucas (1996): Incomplete Markets with Portfolio Choices>` with 
the consistency equations in order to make sure that these equations are satisfied with higher precision.
However, the new converged solution would not differ significantly from the old one.

.. _HL1996TFIter:
===============
The gmod File
===============

:download:`HL1996TFIter.gmod <HL1996TFIter.gmod>`

.. literalinclude:: HL1996TFIter.gmod
    :linenos:
    :language: GDSGE

Notice that, to implement this alternative algorithm, the gmod code uses two features of the toolbox on top of the original example with consistency equations.
First, since this alternative algorithm needs to evaluate the state transition function for the current state
to get the future endogenous state variables that corresponds to each of the future realizations, one needs to include the state transition function
*for each of the current state* as *var_interp*. For the current example, this means 8 state transition functions corresponding to each of the current state.
Accordingly, these state transition functions need to be initialized, updated, and evaluated in the model block. This can be done compactly by using a macro for loop
in the gmod file, replicated below

.. literalinclude:: HL1996TFIter.gmod
    :lines: 53-56
    :lineno-start: 53
    :language: GDSGE

This block expands to 

.. code-block:: GDSGE

    var_interp w1_future_1;
    initial w1_future_1 0.5; % A place holder
    
    var_interp w1_future_2;
    initial w1_future_2 0.5; % A place holder
    
    ...
    
    var_interp w1_future_8;
    initial w1_future_8 0.5; % A place holder 

In particular, the #for ... #end block will repeat the code in the block, and replace the iterator with each value in the value list in the header line starting with #for. And the above code block thus declares
w1_future_1 to w1_future_8 as *var_interp* and initialize their values. Correspondingly, the following block specifies the updates for each of these state transition functions
after a time step of the policy iteration

.. literalinclude:: HL1996TFIter.gmod
    :lines: 61-64
    :lineno-start: 61
    :language: GDSGE

in which *index_current* is a helper function to look up the corresponding current shock index from the returned *var_aux* w1n after each iteration. Therefore, *w1_future_1* indeed corresponds to
the state transition function for the current exogenous state indexed by 1, and so on.

The other feature that maximizes the efficiency of the algorithm is by noticing that the future endogenous states are directly evaluated with the state transition function from the last iteration. 
Then the future endogenous states are used to evaluate necessary future variables using the policy function from the last iteration.
Therefore, given current
endogenous states and exogenous states, the future endogenous states and future variables do not depend on current policy variables, and thus can be evaluated before solving the equation.
This is enabled by defining the *pre_model* block in the gmod code, replicated below

.. literalinclude:: HL1996TFIter.gmod
    :lines: 66-79
    :lineno-start: 66
    :language: GDSGE

As shown, the *pre_model* block essentially evaluates the future endogenous states, using the state transition function that corresponds to the index of the current exogenous state, 
and then evaluates the future variables that are necessary in evaluating the current equation, by feeding the future endogenous states into the policy functions from the last iteration.
Actually, the *pre_model* block does a bit more by also calculating the expectations that enter the inter-temporal equations, as they do not depend on current policy variables either.
These expectation terms, combined with current policy variables, arrive at the inter-temporal equations (the Euler equations for bonds and shares) that enter the system, defined in the model block. It should be clear that any variables defined in the *pre_model* block can be directly used in the *model* block, and for obvious reasons, the *pre_model* block can not use any 
policy variables declared as *var_policy*. Evaluating the state transition functions and expectations beforehand has greatly improved the efficiency of this alternative algorithm (for the current example, it reduces the computation time by half), by avoiding redundant evaluations of objects that do not vary with *var_policy*.

Generally, this alternative algorithm, using the most efficient implementation enabled by procedures above, delivers better performance in computation speed for a time step compared to the algorithm with consistency equations
in :ref:`Heaton and Lucas (1996) <Heaton and Lucas (1996): Incomplete Markets with Portfolio Choices>`. 
The tradeoff in computation time is that the algorithm with consistency equations solves a larger system of equations 
(by including the consistency equations and endogenous states as unknowns) 
and does not allow interpolating for future endogenous states and computing expectation beforehand, 
but this alternative algorithm constructs more *var_interp* and needs evaluate interpolation twice 
-- first to get future endogenous states, then future policy variables. 
On the theoretical ground, the algorithm with consistency equations finds solutions as the limit of a finite-horizon economy 
and thus can also be used to solve stochastic transition paths. 
Besides, it converges more robustly without resorting to ad-hoc dampening.





