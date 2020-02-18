from pygments.lexer import RegexLexer, bygroups
from pygments import token
keywordListStr = """ 
		parameters, var_shock, shock_num, shock_trans, var_state, var_policy, var_interp, model, end, equations, simulate, initial, var_simu, num_periods, num_samples, GNDSGE_EXPECT,GNDSGE_INTERP_VEC,inbound
		"""
keywordList = keywordListStr.split(',')
keywordListPair = [( '(' + p.replace('\n','').replace('\t','').strip() + ')', token.Keyword) for p in keywordList]

keywordListPair

