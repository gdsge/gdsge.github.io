************************************
Toolbox API
************************************

===========================
Matlab Interface
===========================

.. function:: iter_modname([options])

    Run policy iterations.

    :param options: a Matlab struct that contains options and parameters to be overwritten. 
        Notice only options that do not require recompiling can be overwritten. See :ref:`Options`
    :return: a Matlab struct that contains the structure of the problem and converged policy/state transition functions

.. function:: simulate_modname(IterRslt[,options])

    Simulate models using policy/state transition functions contained in Matlab struct IterRslt.
    
    :param IterRslt: results returned by the policy iteration procedure
    :param options: a Matlab struct that contains options and parameters to be overwritten.
    :return: a Matlab struct that contains simulated panels of variables defined in `var_simu`


=======================
Variable declaration
=======================

.. declare:: parameters var1 var2 ...

    Declare parameters.
    Parameters are variables that do not change across states or over time.
    A parameter can be a vector. A vector parameter can be accessed in the model block using round brackets. For example,

    .. code-block:: GDSGE

        parameters var1, var2;
        var1 = 1.0;         % Scalar parameter
        var2 = [2.0,3.0];   % Vector parameter with two elements
        ...
        model;
            a = var1;       % This assigns a to scalar parameter var1 (1.0)
            b = var2(1);    % This assigns b to the first element of parameter var2 (2.0)
            ...
        end;


.. declare:: var_shock var1 var2 ...

    Declare exogenous state variables.
    The number of elements of the cartesian set of `var_shock` is specified by `shock_num`.
    The full transition matrix is specified by `shock_trans`

.. declare:: var_state var1 var2 ...

    Declare endogenous state variables.
    A fixed grid for each state variable should be defined.
    The grid will be used for fixed-grid function approximations such as splines and linear interpolations.
    The range of the grid will be used for adaptive grid methods.

.. declare:: var_interp var1 var2 ...

    Declare state transitions.
    An initial value should be specified for each `var_interp`.
    An update procedure should be specified for each `var_interp` after a policy iteration.
    `var_interp` can be used as functions which take values of `var_state` as arguments in the model block.

    Convergence for policy iterations is checked for `var_interp` across two iterations.

.. declare:: var_policy var1 var2[len2] ...

    Declare policy variables that directly enter the system of equations.

    A `var_policy` can be declared as a vector, for example, var2 of length len2 in the example.
    To access elements of a vector `var_policy` in the model block, use round bracket to index
    or use the prime (') operator.

    For each `var_policy`, its lower and upper bounds entering the equation solver should defined as

    .. code-block:: GDSGE

        inbound var1 var1_lb var1_ub

    If the lower and upper bounds of a `var_policy` cannot be determined ex-ante, specify tight bounds and
    use the adaptive bound option as 

    .. code-block:: GDSGE

        inbound var1 var1_lb var1_ub adaptive(2.0)

    This will adjust bounds by expanding the lower and upper bounds by a factor of 2.0 after each time iteration, 
    if `UseAdpativeBound` is set as one. If option `UseAdpativeBoundInSol` is set to one, after a failed attempt in trying to search
    solutions within the bounds and the equation solver returns an immature step that hits the lower or upper bound,
    the bound will be expanded.

.. declare:: var_aux var1 var2[len2] ...

    Some policy variables of interests are simple functions of `var_state` and `var_policy`, and thus do not need to enter the system of equations
    as unknowns. These variables can be declared as `var_aux`.

    They need to be evaluated in the model block so as to be returned.

.. declare:: var_output var1 var2 ...

    A subset of `var_policy` or `var_aux` of which the function approximation parameters should be constructed.
    These function approximation parameters will be used in simulations if `SIMU_INTERP` is set to one.

.. declare:: var_others var1 var2 ...

    Any variables in the Matlab workspace that needs to be returned.


============================
The model block
===========================

.. declare:: model; ... end;

    Declare the model block. 
    
    The *model;...end;* block defines the system of equations for each collocation point of endogenous states and exogenous states. 
    The equations should be eventually specified in the *equation;...end;* block, in which each line corresponds to one equation in the system.
    Any calculations in order to evaluate these equations are included in the *model* block preceding the *equations* block.

.. declare:: model_init; ... end;

    Declare the model_init block.

    Like the *model;...end;* block, but is called only once at the start of the policy iteration.
    This is often used to define a last period problem which is to solve a potentially different system of equations.

    Can set :rst:option:SkipModelInit=1 to skip this block, so the policy iteration starts with a WarmUp specified in the option.

.. declare:: simulate; ... end;

    Declare the simulate block.

    The simulate block should define the initial exogenous state index and endogenous states (e.g. var1 and var2) as following

    .. code-block:: GDSGE
        
        initial shock 1
        initial var1 some_value1
        initial var2 some_value2

    The simulate block should declare the transition of each endogenous variable as following

    .. code-block:: GDSGE

        var1' = some_variable1
        var2' = some_variable2

    If the transition of the endogenous variable is given by indexing a vector `var_policy` or `var_aux` with the future exogenous state index,
    specify the transition as following

    .. code-block:: GDSGE

        var1' = some_var_policy'
        var2' = some_aux_policy'

    The simulate block should declare variables to be recorded following keyword `var_simu`. 
    A `var_simu` must be contained in `var_policy` or `var_aux` if SIMU_RESOLVE=1, or must be contained in `var_outpu` if SIMU_INTERP=1.

    The simulate block can overwrite options num_samples (default 1) and num_periods (default 1000).

======================================
Utility functions
======================================

.. function:: GDSGE_INVERP_VEC'(var_state1, var_state2, ...)

    Return each *var_interp* evaluated at (var_state1, var_state2, ...) for each realization of exogenous states, 
    returned in the order defined in *var_interp*. For example,

    .. code-block:: GDSGE

        ...
        var_shock z;
        var_state x1 x2;
        var_interp y1 y2 y3;
        ...
        model;
            x1_future' = z';
            x2_future' = z'^2;
            [y1_future',y2_future',y3_future'] = GDSGE_INTERP_VEC'(x1_future',x2_future');
        end;

    :param var_state: values of endogenous states


.. function:: GDSGE_INVERP_VEC'[index](var_state1, var_state2, ...)

    Return each *var_interp* evaluated at (var_state1, var_state2, ...) for each realization of exogenous states, 
    in the order defined in *index*. 
    This can be used to skip evaluations of certain var_interp. For example, the following skips the evaluation of y2.

    .. code-block:: GDSGE

        ...
        var_shock z;
        var_state x1 x2;
        var_interp y1 y2 y3;
        ...
        model;
            x1_future' = z';
            x2_future' = z'^2;
            [y1_future',y3_future'] = GDSGE_INTERP_VEC'[1,3](x1_future',x2_future');
        end;

    :param var_state: values of endogenous states
    :param index: matlab integer vector that specifies the index of *var_interp* returned

.. function:: GDSGE_INVERP_VEC[index](shock_idx, var_state1, var_state2, ...)

    Return each *var_interp* evaluated at (var_state1, var_state2, ...) for exogenous state at *shock_idx*, 
    in the order defined in *var_interp*. For example,

    .. code-block:: GDSGE

        ...
        var_shock z;
        var_state x1 x2;
        var_interp y1 y2 y3;
        ...
        model;
            x1_future = z;
            x2_future = z^2;
            [y1_future,y2_future,y3_future] = GDSGE_INTERP_VEC(shock,x1_future,x2_future);
        end;

    :param shock_idx: the index of exogenous state at which the evaluation is done
    :param var_state: values of endogenous states
    :param index: matlab integer vector that specifies the index of *var_interp* returned.
        Return all *var_interp* if omitted.


.. function:: GDSGE_EXPECT{expression | trans_matrix=shock_trans}

    Calculate the conditional expectation of an expression.

    :param expression: mathematical expression to be calculated
    :param trans_matrix: the Markov transition matrix used to form conditional probability. Defaulted to *shock_trans* if omitted


.. function:: GDSGE_MAX{expression}

    Calculate the maximum of expression across all realizations of exogenous states.

    :param expression: mathematical expression to be calculated

.. function:: GDSGE_MIN{expression}

    Calculate the minimum of expression across all realizations of exogenous states.

    :param expression: mathematical expression to be calculated


======================================
Options
======================================

Options named UPPER_CASE_OPTION require recompiling (via a local or remote compiler) when the the values are changed.

Options named CapitalUpperCaseOption or lower_case_option do not require recompiling, and can be safely specified into an option structure to overwrite existing values. For example

.. code-block:: MATLAB

    >> options.SaveFreq = 100;      % Change saving frequency in policy iterations
    >> IterRslt = iter_modname(options);
    ...
    >> options.num_samples = 100;   % Change number of sample paths in simulations
    >> SimuRslt = simulate_modname(IterRslt,options);


-------------------------
Policy iterations
-------------------------

.. option:: SkipModelInit

    Skip the `model_init` block. Start iterations with `var_interp` in the WarmUp.

.. option:: TolEq

    Tolerance for convergence of *var_interp* across two iterations.
    Default: 1e-6

.. option:: MaxIter

    Maximum iterations for policy iterations. Default: inf

.. option:: MaxMinorIter

    Maximum minor iterations for randomizing initial guesses when solutions are not found. Default: inf

.. option:: UseAdaptiveBound

    Use adaptive bound specified as for example

    .. code-block:: GDSGE

        inbound x 0.0 1.0 adaptive(2)

    which expand the lower and upper bound by a factor of 2 for each state after each iteration

    Takes value 0 or 1 (default).

.. option:: UseAdaptiveBoundInSol

    Use adaptive bound in randomization.
    Takes value 0 (default) or 1.


-------------------------
Simulation
-------------------------

.. option:: SIMU_RESOLVE

    Whether resolving the system of equations in simulations.
    Takes value of 0 or 1 (default).
    Only one of `SIMU_RESOLVE` and `SIMU_INTERP` can take value one.

.. option:: SIMU_INTERP

    Whether directly interpolating the policy and state transition functions in simulations.
    Takes value of 0 (default) or 1. 
    Only one of `SIMU_RESOLVE` and `SIMU_INTERP` can take value one.

.. option:: SimuSeed

    The seed for random number generators in simulations. Default: 0823.

.. option:: EnforceSimuStateInbound

    Whether enforcing endogenous states are inbound for each period, after interpolating state transition functions.
    Effective only when `SIMU_INTERP` = 1

.. option:: num_samples

    Number of sample paths. Default: 1

.. option:: num_periods

    Number of periods of each sample path. Default: 1000

-------------------------
Function approximations
-------------------------


.. option:: USE_SPLINE

    Whether using multi-dimensional linear interpolations or cubic splines with natural end conditions for function approximations.
    Takes value of 0 or 1 (default).

    Only one of USE_SPLINE, USE_PCHIP, USE_ASG can be set to one.
    
    
.. option:: USE_PCHIP

    Whether using shape-preserving cubic interpolations for function approximations.
    Takes value of 0 (default) or 1.

    Only one of USE_SPLINE, USE_PCHIP, USE_ASG can be set to one.

.. option:: USE_ASG

    Whether using shape-preserving cubic interpolations for function approximations.
    Takes value of 0 (default) or 1.

    Only one of USE_SPLINE, USE_PCHIP, USE_ASG can be set to one.

.. option:: INTERP_ORDER

    Takes value of 2 (default) or 4.
    Only effective if USE_SPLINE=1. INTERP_ORDER=2 corresponds to linear interpolations and INTERP_ORDER=4
    corresponds to cubic splines.

.. option:: ExtrapOrder

    The order of extrapolations when extrapolating a spline.
    Takes value of 2 (default) or 4.
    Only effective if USE_SPLINE=1 and INTERP_ORDER=4.

.. option:: AsgMaxLevel

    The maximum level used in the adaptive sparse grid method.  Default 10.
    Only effective if USE_ASG=1.

.. option:: AsgMinLevel

    The minimum level used in the adaptive sparse grid method.  Default 4.
    Only effective if USE_ASG=1.

.. option:: AsgThreshold

    The tolerance for refinement in the adaptive sparse grid method. Default 1e-2.
    Only effective if USE_ASG=1.

.. option:: AsgOutputMaxLevel

    The max level used in the adaptive sparse grid method for `var_output`.  Default 10.
    Only effective if USE_ASG=1.

.. option:: AsgOutputThreshold

    The tolerance for refinement in the adaptive sparse grid method for `var_output`. Default MIN(1e-2, AsgThreshold).
    Only effective if USE_ASG=1.

.. option:: AsgFixGrid

    Whether fix the adaptive grid to the one passed in struct WarmUp.
    Takes value of 0 (default) or 1.

----------------------------
Equation Solver
----------------------------

.. option:: TolSol

    Absolute residual tolerance in equation solving. Default: 1e-8

.. option:: SolMaxIter

    Maximum number of function evaluations in equation solving. Default: 200

-------------------------
Print and save
-------------------------

.. option:: PrintFreq

    Frequency of printing information in policy iterations

.. option:: SaveFreq

    Frequency of saving in policy iterations

.. option:: SimuPrintFreq

    Frequency of printing information in simulations

.. option:: SimuSaveFreq

    Frequency of saving in simulations


----------------------------
Miscellaneous
----------------------------

.. option:: NumThreads

    Number of (Openmp) threads in policy iterations and simulations.
    Default: the number of cores (via Matlab function ``feature('numcores')``)


----------------------------
DEBUG
----------------------------

.. option:: GDSGE_DEBUG_EVAL_ONLY

    Only evaluate the system of equations instead of solving it.

.. option:: IterSaveAll

    Save all variables in the workspace after policy iterations.
    


