typedef double Doub;
typedef int Int;

template <class Lambda, class T>
T rtnewt(Lambda funcd, const Doub x1, const Doub x2, const T x0, const Doub xacc) {
	const Int JMAX=100;
    const Doub LINE_STEP=0.1;
	T rtn=x0;
	for (Int j=0;j<JMAX;j++) {
        T df;
		T f=funcd(rtn, &df);
		T dx=f/df;
		rtn -= dx;
		if ((x1-rtn)*(rtn-x2) < 0.0)
			return rtn;
		if (abs(dx) < xacc) return rtn;
	}
    return rtn;
}