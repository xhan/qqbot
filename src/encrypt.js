var RSA = function() {
    function g(z, t) {
        return new ar(z, t)
    }
    function ah(aA, aB) {
        var t = "";
        var z = 0;
        while (z + aB < aA.length) {
            t += aA.substring(z, z + aB) + "\n";
            z += aB
        }
        return t + aA.substring(z, aA.length)
    }
    function r(t) {
        if (t < 16) {
            return "0" + t.toString(16)
        } else {
            return t.toString(16)
        }
    }
    function af(aB, aE) {
        if (aE < aB.length + 11) {
            console.log("Message too long for RSA");
            return null
        }
        var aD = new Array();
        var aA = aB.length - 1;
        while (aA >= 0 && aE > 0) {
            var aC = aB.charCodeAt(aA--);
            aD[--aE] = aC
        }
        aD[--aE] = 0;
        var z = new ad();
        var t = new Array();
        while (aE > 2) {
            t[0] = 0;
            while (t[0] == 0) {
                z.nextBytes(t)
            }
            aD[--aE] = t[0]
        }
        aD[--aE] = 2;
        aD[--aE] = 0;
        return new ar(aD)
    }
    function L() {
        this.n = null;
        this.e = 0;
        this.d = null;
        this.p = null;
        this.q = null;
        this.dmp1 = null;
        this.dmq1 = null;
        this.coeff = null
    }
    function o(z, t) {
        if (z != null && t != null && z.length > 0 && t.length > 0) {
            this.n = g(z, 16);
            this.e = parseInt(t, 16)
        } else {
            console.log("Invalid RSA public key")
        }
    }
    function W(t) {
        return t.modPowInt(this.e, this.n)
    }
    function p(aA) {
        var t = af(aA, (this.n.bitLength() + 7) >> 3);
        if (t == null) {
            return null
        }
        var aB = this.doPublic(t);
        if (aB == null) {
            return null
        }
        var z = aB.toString(16);
        if ((z.length & 1) == 0) {
            return z
        } else {
            return "0" + z
        }
    }
    L.prototype.doPublic = W;
    L.prototype.setPublic = o;
    L.prototype.encrypt = p;
    var aw;
    var ai = 244837814094590;
    var Z = ((ai & 16777215) == 15715070);
    function ar(z, t, aA) {
        if (z != null) {
            if ("number" == typeof z) {
                this.fromNumber(z, t, aA)
            } else {
                if (t == null && "string" != typeof z) {
                    this.fromString(z, 256)
                } else {
                    this.fromString(z, t)
                }
            }
        }
    }
    function h() {
        return new ar(null)
    }
    function b(aC, t, z, aB, aE, aD) {
        while (--aD >= 0) {
            var aA = t * this[aC++] + z[aB] + aE;
            aE = Math.floor(aA / 67108864);
            z[aB++] = aA & 67108863
        }
        return aE
    }
    function ay(aC, aH, aI, aB, aF, t) {
        var aE = aH & 32767,
        aG = aH >> 15;
        while (--t >= 0) {
            var aA = this[aC] & 32767;
            var aD = this[aC++] >> 15;
            var z = aG * aA + aD * aE;
            aA = aE * aA + ((z & 32767) << 15) + aI[aB] + (aF & 1073741823);
            aF = (aA >>> 30) + (z >>> 15) + aG * aD + (aF >>> 30);
            aI[aB++] = aA & 1073741823
        }
        return aF
    }
    function ax(aC, aH, aI, aB, aF, t) {
        var aE = aH & 16383,
        aG = aH >> 14;
        while (--t >= 0) {
            var aA = this[aC] & 16383;
            var aD = this[aC++] >> 14;
            var z = aG * aA + aD * aE;
            aA = aE * aA + ((z & 16383) << 14) + aI[aB] + aF;
            aF = (aA >> 28) + (z >> 14) + aG * aD;
            aI[aB++] = aA & 268435455
        }
        return aF
    }
    // if (Z && (navigator.appName == "Microsoft Internet Explorer")) {
    //     ar.prototype.am = ay;
    //     aw = 30
    // } else {
    //     if (Z && (navigator.appName != "Netscape")) {
    //         ar.prototype.am = b;
    //         aw = 26
    //     } else {
    //       ar.prototype.am = ax;
    //       aw = 28
    //     }
    // }
    ar.prototype.am = ax;
    aw = 28

    ar.prototype.DB = aw;
    ar.prototype.DM = ((1 << aw) - 1);
    ar.prototype.DV = (1 << aw);
    var aa = 52;
    ar.prototype.FV = Math.pow(2, aa);
    ar.prototype.F1 = aa - aw;
    ar.prototype.F2 = 2 * aw - aa;
    var ae = "0123456789abcdefghijklmnopqrstuvwxyz";
    var ag = new Array();
    var ap, v;
    ap = "0".charCodeAt(0);
    for (v = 0; v <= 9; ++v) {
        ag[ap++] = v
    }
    ap = "a".charCodeAt(0);
    for (v = 10; v < 36; ++v) {
        ag[ap++] = v
    }
    ap = "A".charCodeAt(0);
    for (v = 10; v < 36; ++v) {
        ag[ap++] = v
    }
    function az(t) {
        return ae.charAt(t)
    }
    function A(z, t) {
        var aA = ag[z.charCodeAt(t)];
        return (aA == null) ? -1 : aA
    }
    function Y(z) {
        for (var t = this.t - 1; t >= 0; --t) {
            z[t] = this[t]
        }
        z.t = this.t;
        z.s = this.s
    }
    function n(t) {
        this.t = 1;
        this.s = (t < 0) ? -1 : 0;
        if (t > 0) {
            this[0] = t
        } else {
            if (t < -1) {
                this[0] = t + DV
            } else {
                this.t = 0
            }
        }
    }
    function c(t) {
        var z = h();
        z.fromInt(t);
        return z
    }
    function w(aE, z) {
        var aB;
        if (z == 16) {
            aB = 4
        } else {
            if (z == 8) {
                aB = 3
            } else {
                if (z == 256) {
                    aB = 8
                } else {
                    if (z == 2) {
                        aB = 1
                    } else {
                        if (z == 32) {
                            aB = 5
                        } else {
                            if (z == 4) {
                                aB = 2
                            } else {
                                this.fromRadix(aE, z);
                                return
                            }
                        }
                    }
                }
            }
        }
        this.t = 0;
        this.s = 0;
        var aD = aE.length,
        aA = false,
        aC = 0;
        while (--aD >= 0) {
            var t = (aB == 8) ? aE[aD] & 255 : A(aE, aD);
            if (t < 0) {
                if (aE.charAt(aD) == "-") {
                    aA = true
                }
                continue
            }
            aA = false;
            if (aC == 0) {
                this[this.t++] = t
            } else {
                if (aC + aB > this.DB) {
                    this[this.t - 1] |= (t & ((1 << (this.DB - aC)) - 1)) << aC;
                    this[this.t++] = (t >> (this.DB - aC))
                } else {
                    this[this.t - 1] |= t << aC
                }
            }
            aC += aB;
            if (aC >= this.DB) {
                aC -= this.DB
            }
        }
        if (aB == 8 && (aE[0] & 128) != 0) {
            this.s = -1;
            if (aC > 0) {
                this[this.t - 1] |= ((1 << (this.DB - aC)) - 1) << aC
            }
        }
        this.clamp();
        if (aA) {
            ar.ZERO.subTo(this, this)
        }
    }
    function O() {
        var t = this.s & this.DM;
        while (this.t > 0 && this[this.t - 1] == t) {--this.t
        }
    }
    function q(z) {
        if (this.s < 0) {
            return "-" + this.negate().toString(z)
        }
        var aA;
        if (z == 16) {
            aA = 4
        } else {
            if (z == 8) {
                aA = 3
            } else {
                if (z == 2) {
                    aA = 1
                } else {
                    if (z == 32) {
                        aA = 5
                    } else {
                        if (z == 4) {
                            aA = 2
                        } else {
                            return this.toRadix(z)
                        }
                    }
                }
            }
        }
        var aC = (1 << aA) - 1,
        aF,
        t = false,
        aD = "",
        aB = this.t;
        var aE = this.DB - (aB * this.DB) % aA;
        if (aB-->0) {
            if (aE < this.DB && (aF = this[aB] >> aE) > 0) {
                t = true;
                aD = az(aF)
            }
            while (aB >= 0) {
                if (aE < aA) {
                    aF = (this[aB] & ((1 << aE) - 1)) << (aA - aE);
                    aF |= this[--aB] >> (aE += this.DB - aA)
                } else {
                    aF = (this[aB] >> (aE -= aA)) & aC;
                    if (aE <= 0) {
                        aE += this.DB; --aB
                    }
                }
                if (aF > 0) {
                    t = true
                }
                if (t) {
                    aD += az(aF)
                }
            }
        }
        return t ? aD: "0"
    }
    function R() {
        var t = h();
        ar.ZERO.subTo(this, t);
        return t
    }
    function al() {
        return (this.s < 0) ? this.negate() : this
    }
    function G(t) {
        var aA = this.s - t.s;
        if (aA != 0) {
            return aA
        }
        var z = this.t;
        aA = z - t.t;
        if (aA != 0) {
            return aA
        }
        while (--z >= 0) {
            if ((aA = this[z] - t[z]) != 0) {
                return aA
            }
        }
        return 0
    }
    function j(z) {
        var aB = 1,
        aA;
        if ((aA = z >>> 16) != 0) {
            z = aA;
            aB += 16
        }
        if ((aA = z >> 8) != 0) {
            z = aA;
            aB += 8
        }
        if ((aA = z >> 4) != 0) {
            z = aA;
            aB += 4
        }
        if ((aA = z >> 2) != 0) {
            z = aA;
            aB += 2
        }
        if ((aA = z >> 1) != 0) {
            z = aA;
            aB += 1
        }
        return aB
    }
    function u() {
        if (this.t <= 0) {
            return 0
        }
        return this.DB * (this.t - 1) + j(this[this.t - 1] ^ (this.s & this.DM))
    }
    function aq(aA, z) {
        var t;
        for (t = this.t - 1; t >= 0; --t) {
            z[t + aA] = this[t]
        }
        for (t = aA - 1; t >= 0; --t) {
            z[t] = 0
        }
        z.t = this.t + aA;
        z.s = this.s
    }
    function X(aA, z) {
        for (var t = aA; t < this.t; ++t) {
            z[t - aA] = this[t]
        }
        z.t = Math.max(this.t - aA, 0);
        z.s = this.s
    }
    function s(aF, aB) {
        var z = aF % this.DB;
        var t = this.DB - z;
        var aD = (1 << t) - 1;
        var aC = Math.floor(aF / this.DB),
        aE = (this.s << z) & this.DM,
        aA;
        for (aA = this.t - 1; aA >= 0; --aA) {
            aB[aA + aC + 1] = (this[aA] >> t) | aE;
            aE = (this[aA] & aD) << z
        }
        for (aA = aC - 1; aA >= 0; --aA) {
            aB[aA] = 0
        }
        aB[aC] = aE;
        aB.t = this.t + aC + 1;
        aB.s = this.s;
        aB.clamp()
    }
    function l(aE, aB) {
        aB.s = this.s;
        var aC = Math.floor(aE / this.DB);
        if (aC >= this.t) {
            aB.t = 0;
            return
        }
        var z = aE % this.DB;
        var t = this.DB - z;
        var aD = (1 << z) - 1;
        aB[0] = this[aC] >> z;
        for (var aA = aC + 1; aA < this.t; ++aA) {
            aB[aA - aC - 1] |= (this[aA] & aD) << t;
            aB[aA - aC] = this[aA] >> z
        }
        if (z > 0) {
            aB[this.t - aC - 1] |= (this.s & aD) << t
        }
        aB.t = this.t - aC;
        aB.clamp()
    }
    function ab(z, aB) {
        var aA = 0,
        aC = 0,
        t = Math.min(z.t, this.t);
        while (aA < t) {
            aC += this[aA] - z[aA];
            aB[aA++] = aC & this.DM;
            aC >>= this.DB
        }
        if (z.t < this.t) {
            aC -= z.s;
            while (aA < this.t) {
                aC += this[aA];
                aB[aA++] = aC & this.DM;
                aC >>= this.DB
            }
            aC += this.s
        } else {
            aC += this.s;
            while (aA < z.t) {
                aC -= z[aA];
                aB[aA++] = aC & this.DM;
                aC >>= this.DB
            }
            aC -= z.s
        }
        aB.s = (aC < 0) ? -1 : 0;
        if (aC < -1) {
            aB[aA++] = this.DV + aC
        } else {
            if (aC > 0) {
                aB[aA++] = aC
            }
        }
        aB.t = aA;
        aB.clamp()
    }
    function D(z, aB) {
        var t = this.abs(),
        aC = z.abs();
        var aA = t.t;
        aB.t = aA + aC.t;
        while (--aA >= 0) {
            aB[aA] = 0
        }
        for (aA = 0; aA < aC.t; ++aA) {
            aB[aA + t.t] = t.am(0, aC[aA], aB, aA, 0, t.t)
        }
        aB.s = 0;
        aB.clamp();
        if (this.s != z.s) {
            ar.ZERO.subTo(aB, aB)
        }
    }
    function Q(aA) {
        var t = this.abs();
        var z = aA.t = 2 * t.t;
        while (--z >= 0) {
            aA[z] = 0
        }
        for (z = 0; z < t.t - 1; ++z) {
            var aB = t.am(z, t[z], aA, 2 * z, 0, 1);
            if ((aA[z + t.t] += t.am(z + 1, 2 * t[z], aA, 2 * z + 1, aB, t.t - z - 1)) >= t.DV) {
                aA[z + t.t] -= t.DV;
                aA[z + t.t + 1] = 1
            }
        }
        if (aA.t > 0) {
            aA[aA.t - 1] += t.am(z, t[z], aA, 2 * z, 0, 1)
        }
        aA.s = 0;
        aA.clamp()
    }
    function E(aI, aF, aE) {
        var aO = aI.abs();
        if (aO.t <= 0) {
            return
        }
        var aG = this.abs();
        if (aG.t < aO.t) {
            if (aF != null) {
                aF.fromInt(0)
            }
            if (aE != null) {
                this.copyTo(aE)
            }
            return
        }
        if (aE == null) {
            aE = h()
        }
        var aC = h(),
        z = this.s,
        aH = aI.s;
        var aN = this.DB - j(aO[aO.t - 1]);
        if (aN > 0) {
            aO.lShiftTo(aN, aC);
            aG.lShiftTo(aN, aE)
        } else {
            aO.copyTo(aC);
            aG.copyTo(aE)
        }
        var aK = aC.t;
        var aA = aC[aK - 1];
        if (aA == 0) {
            return
        }
        var aJ = aA * (1 << this.F1) + ((aK > 1) ? aC[aK - 2] >> this.F2: 0);
        var aR = this.FV / aJ,
        aQ = (1 << this.F1) / aJ,
        aP = 1 << this.F2;
        var aM = aE.t,
        aL = aM - aK,
        aD = (aF == null) ? h() : aF;
        aC.dlShiftTo(aL, aD);
        if (aE.compareTo(aD) >= 0) {
            aE[aE.t++] = 1;
            aE.subTo(aD, aE)
        }
        ar.ONE.dlShiftTo(aK, aD);
        aD.subTo(aC, aC);
        while (aC.t < aK) {
            aC[aC.t++] = 0
        }
        while (--aL >= 0) {
            var aB = (aE[--aM] == aA) ? this.DM: Math.floor(aE[aM] * aR + (aE[aM - 1] + aP) * aQ);
            if ((aE[aM] += aC.am(0, aB, aE, aL, 0, aK)) < aB) {
                aC.dlShiftTo(aL, aD);
                aE.subTo(aD, aE);
                while (aE[aM] < --aB) {
                    aE.subTo(aD, aE)
                }
            }
        }
        if (aF != null) {
            aE.drShiftTo(aK, aF);
            if (z != aH) {
                ar.ZERO.subTo(aF, aF)
            }
        }
        aE.t = aK;
        aE.clamp();
        if (aN > 0) {
            aE.rShiftTo(aN, aE)
        }
        if (z < 0) {
            ar.ZERO.subTo(aE, aE)
        }
    }
    function N(t) {
        var z = h();
        this.abs().divRemTo(t, null, z);
        if (this.s < 0 && z.compareTo(ar.ZERO) > 0) {
            t.subTo(z, z)
        }
        return z
    }
    function K(t) {
        this.m = t
    }
    function V(t) {
        if (t.s < 0 || t.compareTo(this.m) >= 0) {
            return t.mod(this.m)
        } else {
            return t
        }
    }
    function ak(t) {
        return t
    }
    function J(t) {
        t.divRemTo(this.m, null, t)
    }
    function H(t, aA, z) {
        t.multiplyTo(aA, z);
        this.reduce(z)
    }
    function au(t, z) {
        t.squareTo(z);
        this.reduce(z)
    }
    K.prototype.convert = V;
    K.prototype.revert = ak;
    K.prototype.reduce = J;
    K.prototype.mulTo = H;
    K.prototype.sqrTo = au;
    function B() {
        if (this.t < 1) {
            return 0
        }
        var t = this[0];
        if ((t & 1) == 0) {
            return 0
        }
        var z = t & 3;
        z = (z * (2 - (t & 15) * z)) & 15;
        z = (z * (2 - (t & 255) * z)) & 255;
        z = (z * (2 - (((t & 65535) * z) & 65535))) & 65535;
        z = (z * (2 - t * z % this.DV)) % this.DV;
        return (z > 0) ? this.DV - z: -z
    }
    function f(t) {
        this.m = t;
        this.mp = t.invDigit();
        this.mpl = this.mp & 32767;
        this.mph = this.mp >> 15;
        this.um = (1 << (t.DB - 15)) - 1;
        this.mt2 = 2 * t.t
    }
    function aj(t) {
        var z = h();
        t.abs().dlShiftTo(this.m.t, z);
        z.divRemTo(this.m, null, z);
        if (t.s < 0 && z.compareTo(ar.ZERO) > 0) {
            this.m.subTo(z, z)
        }
        return z
    }
    function at(t) {
        var z = h();
        t.copyTo(z);
        this.reduce(z);
        return z
    }
    function P(t) {
        while (t.t <= this.mt2) {
            t[t.t++] = 0
        }
        for (var aA = 0; aA < this.m.t; ++aA) {
            var z = t[aA] & 32767;
            var aB = (z * this.mpl + (((z * this.mph + (t[aA] >> 15) * this.mpl) & this.um) << 15)) & t.DM;
            z = aA + this.m.t;
            t[z] += this.m.am(0, aB, t, aA, 0, this.m.t);
            while (t[z] >= t.DV) {
                t[z] -= t.DV;
                t[++z]++
            }
        }
        t.clamp();
        t.drShiftTo(this.m.t, t);
        if (t.compareTo(this.m) >= 0) {
            t.subTo(this.m, t)
        }
    }
    function am(t, z) {
        t.squareTo(z);
        this.reduce(z)
    }
    function y(t, aA, z) {
        t.multiplyTo(aA, z);
        this.reduce(z)
    }
    f.prototype.convert = aj;
    f.prototype.revert = at;
    f.prototype.reduce = P;
    f.prototype.mulTo = y;
    f.prototype.sqrTo = am;
    function i() {
        return ((this.t > 0) ? (this[0] & 1) : this.s) == 0
    }
    function x(aF, aG) {
        if (aF > 4294967295 || aF < 1) {
            return ar.ONE
        }
        var aE = h(),
        aA = h(),
        aD = aG.convert(this),
        aC = j(aF) - 1;
        aD.copyTo(aE);
        while (--aC >= 0) {
            aG.sqrTo(aE, aA);
            if ((aF & (1 << aC)) > 0) {
                aG.mulTo(aA, aD, aE)
            } else {
                var aB = aE;
                aE = aA;
                aA = aB
            }
        }
        return aG.revert(aE)
    }
    function an(aA, t) {
        var aB;
        if (aA < 256 || t.isEven()) {
            aB = new K(t)
        } else {
            aB = new f(t)
        }
        return this.exp(aA, aB)
    }
    ar.prototype.copyTo = Y;
    ar.prototype.fromInt = n;
    ar.prototype.fromString = w;
    ar.prototype.clamp = O;
    ar.prototype.dlShiftTo = aq;
    ar.prototype.drShiftTo = X;
    ar.prototype.lShiftTo = s;
    ar.prototype.rShiftTo = l;
    ar.prototype.subTo = ab;
    ar.prototype.multiplyTo = D;
    ar.prototype.squareTo = Q;
    ar.prototype.divRemTo = E;
    ar.prototype.invDigit = B;
    ar.prototype.isEven = i;
    ar.prototype.exp = x;
    ar.prototype.toString = q;
    ar.prototype.negate = R;
    ar.prototype.abs = al;
    ar.prototype.compareTo = G;
    ar.prototype.bitLength = u;
    ar.prototype.mod = N;
    ar.prototype.modPowInt = an;
    ar.ZERO = c(0);
    ar.ONE = c(1);
    var m;
    var U;
    var ac;
    function d(t) {
        U[ac++] ^= t & 255;
        U[ac++] ^= (t >> 8) & 255;
        U[ac++] ^= (t >> 16) & 255;
        U[ac++] ^= (t >> 24) & 255;
        if (ac >= M) {
            ac -= M
        }
    }
    function T() {
        d(new Date().getTime())
    }
    if (U == null) {
        U = new Array();
        ac = 0;
        var I;
        // if (navigator.appName == "Netscape" && navigator.appVersion < "5" && window.crypto && window.crypto.random) {
        //     var F = window.crypto.random(32);
        //     for (I = 0; I < F.length; ++I) {
        //         U[ac++] = F.charCodeAt(I) & 255
        //     }
        // }
        while (ac < M) {
            I = Math.floor(65536 * Math.random());
            U[ac++] = I >>> 8;
            U[ac++] = I & 255
        }
        ac = 0;
        T()
    }
    function C() {
        if (m == null) {
            T();
            m = ao();
            m.init(U);
            for (ac = 0; ac < U.length; ++ac) {
                U[ac] = 0
            }
            ac = 0
        }
        return m.next()
    }
    function av(z) {
        var t;
        for (t = 0; t < z.length; ++t) {
            z[t] = C()
        }
    }
    function ad() {}
    ad.prototype.nextBytes = av;
    function k() {
        this.i = 0;
        this.j = 0;
        this.S = new Array()
    }
    function e(aC) {
        var aB, z, aA;
        for (aB = 0; aB < 256; ++aB) {
            this.S[aB] = aB
        }
        z = 0;
        for (aB = 0; aB < 256; ++aB) {
            z = (z + this.S[aB] + aC[aB % aC.length]) & 255;
            aA = this.S[aB];
            this.S[aB] = this.S[z];
            this.S[z] = aA
        }
        this.i = 0;
        this.j = 0
    }
    function a() {
        var z;
        this.i = (this.i + 1) & 255;
        this.j = (this.j + this.S[this.i]) & 255;
        z = this.S[this.i];
        this.S[this.i] = this.S[this.j];
        this.S[this.j] = z;
        return this.S[(z + this.S[this.i]) & 255]
    }
    k.prototype.init = e;
    k.prototype.next = a;
    function ao() {
        return new k()
    }
    var M = 256;
    function S(aB, aA, z) {
        aA = "F20CE00BAE5361F8FA3AE9CEFA495362FF7DA1BA628F64A347F0A8C012BF0B254A30CD92ABFFE7A6EE0DC424CB6166F8819EFA5BCCB20EDFB4AD02E412CCF579B1CA711D55B8B0B3AEB60153D5E0693A2A86F3167D7847A0CB8B00004716A9095D9BADC977CBB804DBDCBA6029A9710869A453F27DFDDF83C016D928B3CBF4C7";
        z = "3";
        var t = new L();
        t.setPublic(aA, z);
        return t.encrypt(aB)
    }
    return {
        rsa_encrypt: S
    }
} ();

(function(r) {
    var s = "",
    a = 0,
    g = [],
    x = [],
    y = 0,
    u = 0,
    m = [],
    t = [],
    n = true;
    function e() {
        return Math.round(Math.random() * 4294967295)
    }
    function i(C, D, z) {
        if (!z || z > 4) {
            z = 4
        }
        var A = 0;
        for (var B = D; B < D + z; B++) {
            A <<= 8;
            A |= C[B]
        }
        return (A & 4294967295) >>> 0
    }
    function b(A, B, z) {
        A[B + 3] = (z >> 0) & 255;
        A[B + 2] = (z >> 8) & 255;
        A[B + 1] = (z >> 16) & 255;
        A[B + 0] = (z >> 24) & 255
    }
    function w(C) {
        if (!C) {
            return ""
        }
        var z = "";
        for (var A = 0; A < C.length; A++) {
            var B = Number(C[A]).toString(16);
            if (B.length == 1) {
                B = "0" + B
            }
            z += B
        }
        return z
    }
    function v(A) {
        var B = "";
        for (var z = 0; z < A.length; z += 2) {
            B += String.fromCharCode(parseInt(A.substr(z, 2), 16))
        }
        return B
    }
    function c(C, z) {
        if (!C) {
            return ""
        }
        if (z) {
            C = k(C)
        }
        var B = [];
        for (var A = 0; A < C.length; A++) {
            B[A] = C.charCodeAt(A)
        }
        return w(B)
    }
    function k(C) {
        var B, D, A = [],
        z = C.length;
        for (B = 0; B < z; B++) {
            D = C.charCodeAt(B);
            if (D > 0 && D <= 127) {
                A.push(C.charAt(B))
            } else {
                if (D >= 128 && D <= 2047) {
                    A.push(String.fromCharCode(192 | ((D >> 6) & 31)), String.fromCharCode(128 | (D & 63)))
                } else {
                    if (D >= 2048 && D <= 65535) {
                        A.push(String.fromCharCode(224 | ((D >> 12) & 15)), String.fromCharCode(128 | ((D >> 6) & 63)), String.fromCharCode(128 | (D & 63)))
                    }
                }
            }
        }
        return A.join("")
    }
    function h(B) {
        g = new Array(8);
        x = new Array(8);
        y = u = 0;
        n = true;
        a = 0;
        var z = B.length;
        var C = 0;
        a = (z + 10) % 8;
        if (a != 0) {
            a = 8 - a
        }
        m = new Array(z + a + 10);
        g[0] = ((e() & 248) | a) & 255;
        for (var A = 1; A <= a; A++) {
            g[A] = e() & 255
        }
        a++;
        for (var A = 0; A < 8; A++) {
            x[A] = 0
        }
        C = 1;
        while (C <= 2) {
            if (a < 8) {
                g[a++] = e() & 255;
                C++
            }
            if (a == 8) {
                p()
            }
        }
        var A = 0;
        while (z > 0) {
            if (a < 8) {
                g[a++] = B[A++];
                z--
            }
            if (a == 8) {
                p()
            }
        }
        C = 1;
        while (C <= 7) {
            if (a < 8) {
                g[a++] = 0;
                C++
            }
            if (a == 8) {
                p()
            }
        }
        return m
    }
    function q(D) {
        var C = 0;
        var A = new Array(8);
        var z = D.length;
        t = D;
        if (z % 8 != 0 || z < 16) {
            return null
        }
        x = l(D);
        a = x[0] & 7;
        C = z - a - 10;
        if (C < 0) {
            return null
        }
        for (var B = 0; B < A.length; B++) {
            A[B] = 0
        }
        m = new Array(C);
        u = 0;
        y = 8;
        a++;
        var E = 1;
        while (E <= 2) {
            if (a < 8) {
                a++;
                E++
            }
            if (a == 8) {
                A = D;
                if (!f()) {
                    return null
                }
            }
        }
        var B = 0;
        while (C != 0) {
            if (a < 8) {
                m[B] = (A[u + a] ^ x[a]) & 255;
                B++;
                C--;
                a++
            }
            if (a == 8) {
                A = D;
                u = y - 8;
                if (!f()) {
                    return null
                }
            }
        }
        for (E = 1; E < 8; E++) {
            if (a < 8) {
                if ((A[u + a] ^ x[a]) != 0) {
                    return null
                }
                a++
            }
            if (a == 8) {
                A = D;
                u = y;
                if (!f()) {
                    return null
                }
            }
        }
        return m
    }
    function p() {
        for (var z = 0; z < 8; z++) {
            if (n) {
                g[z] ^= x[z]
            } else {
                g[z] ^= m[u + z]
            }
        }
        var A = j(g);
        for (var z = 0; z < 8; z++) {
            m[y + z] = A[z] ^ x[z];
            x[z] = g[z]
        }
        u = y;
        y += 8;
        a = 0;
        n = false
    }
    function j(A) {
        var B = 16;
        var G = i(A, 0, 4);
        var F = i(A, 4, 4);
        var I = i(s, 0, 4);
        var H = i(s, 4, 4);
        var E = i(s, 8, 4);
        var D = i(s, 12, 4);
        var C = 0;
        var J = 2654435769 >>> 0;
        while (B-->0) {
            C += J;
            C = (C & 4294967295) >>> 0;
            G += ((F << 4) + I) ^ (F + C) ^ ((F >>> 5) + H);
            G = (G & 4294967295) >>> 0;
            F += ((G << 4) + E) ^ (G + C) ^ ((G >>> 5) + D);
            F = (F & 4294967295) >>> 0
        }
        var K = new Array(8);
        b(K, 0, G);
        b(K, 4, F);
        return K
    }
    function l(A) {
        var B = 16;
        var G = i(A, 0, 4);
        var F = i(A, 4, 4);
        var I = i(s, 0, 4);
        var H = i(s, 4, 4);
        var E = i(s, 8, 4);
        var D = i(s, 12, 4);
        var C = 3816266640 >>> 0;
        var J = 2654435769 >>> 0;
        while (B-->0) {
            F -= ((G << 4) + E) ^ (G + C) ^ ((G >>> 5) + D);
            F = (F & 4294967295) >>> 0;
            G -= ((F << 4) + I) ^ (F + C) ^ ((F >>> 5) + H);
            G = (G & 4294967295) >>> 0;
            C -= J;
            C = (C & 4294967295) >>> 0
        }
        var K = new Array(8);
        b(K, 0, G);
        b(K, 4, F);
        return K
    }
    function f() {
        var z = t.length;
        for (var A = 0; A < 8; A++) {
            x[A] ^= t[y + A]
        }
        x = l(x);
        y += 8;
        a = 0;
        return true
    }

    // 将字符串转换为int数组
    // D：字符串
    // C：字符串是否为非16进制字符串
    function o(D, C) {
        var B = [];
        if (C) {
            for (var A = 0; A < D.length; A++) {
                B[A] = D.charCodeAt(A) & 255
            }
        } else {
            var z = 0;
            for (var A = 0; A < D.length; A += 2) {
                B[z++] = parseInt(D.substr(A, 2), 16)
            }
        }
        return B
    }
    r.TEA = {
        encrypt: function(C, B) {
            var A = o(C, B);
            var z = h(A);
            return w(z)
        },

        enAsBase64: function(E, D) {
            var C = o(E, D);
            var B = h(C);
            var z = "";
            for (var A = 0; A < B.length; A++) {
                z += String.fromCharCode(B[A])
            }
            return btoa(z)
        },
        decrypt: function(B) {
            var A = o(B, false);
            var z = q(A);
            return w(z)
        },
        initkey: function(z, A) {
            s = o(z, A)
        },
        bytesToStr: v,
        strToBytes: c,
        bytesInStr: w,
        dataFromStr: o
    };
    var d = {};
    d.PADCHAR = "=";
    d.ALPHA = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    d.getbyte = function(B, A) {
        var z = B.charCodeAt(A);
        if (z > 255) {
            throw "INVALID_CHARACTER_ERR: DOM Exception 5"
        }
        return z
    };
    d.encode = function(D) {
        if (arguments.length != 1) {
            throw "SyntaxError: Not enough arguments"
        }
        var A = d.PADCHAR;
        var F = d.ALPHA;
        var E = d.getbyte;
        var C, G;
        var z = [];
        D = "" + D;
        var B = D.length - D.length % 3;
        if (D.length == 0) {
            return D
        }
        for (C = 0; C < B; C += 3) {
            G = (E(D, C) << 16) | (E(D, C + 1) << 8) | E(D, C + 2);
            z.push(F.charAt(G >> 18));
            z.push(F.charAt((G >> 12) & 63));
            z.push(F.charAt((G >> 6) & 63));
            z.push(F.charAt(G & 63))
        }
        switch (D.length - B) {
        case 1:
            G = E(D, C) << 16;
            z.push(F.charAt(G >> 18) + F.charAt((G >> 12) & 63) + A + A);
            break;
        case 2:
            G = (E(D, C) << 16) | (E(D, C + 1) << 8);
            z.push(F.charAt(G >> 18) + F.charAt((G >> 12) & 63) + F.charAt((G >> 6) & 63) + A);
            break
        }
        return z.join("")
    };
    if (!global.btoa) {
        global.btoa = d.encode
    }
})(global);

var Encryption = function() {
    var hexcase = 1;
    var b64pad = "";
    var chrsz = 8;
    var mode = 32;
    function md5(s) {
        return hex_md5(s)
    }
    function hex_md5(s) {
        return binl2hex(core_md5(str2binl(s), s.length * chrsz))
    }
    function str_md5(s) {
        return binl2str(core_md5(str2binl(s), s.length * chrsz))
    }
    function hex_hmac_md5(key, data) {
        return binl2hex(core_hmac_md5(key, data))
    }
    function b64_hmac_md5(key, data) {
        return binl2b64(core_hmac_md5(key, data))
    }
    function str_hmac_md5(key, data) {
        return binl2str(core_hmac_md5(key, data))
    }
    function core_md5(x, len) {
        x[len >> 5] |= 128 << ((len) % 32);
        x[(((len + 64) >>> 9) << 4) + 14] = len;
        var a = 1732584193;
        var b = -271733879;
        var c = -1732584194;
        var d = 271733878;
        for (var i = 0; i < x.length; i += 16) {
            var olda = a;
            var oldb = b;
            var oldc = c;
            var oldd = d;
            a = md5_ff(a, b, c, d, x[i + 0], 7, -680876936);
            d = md5_ff(d, a, b, c, x[i + 1], 12, -389564586);
            c = md5_ff(c, d, a, b, x[i + 2], 17, 606105819);
            b = md5_ff(b, c, d, a, x[i + 3], 22, -1044525330);
            a = md5_ff(a, b, c, d, x[i + 4], 7, -176418897);
            d = md5_ff(d, a, b, c, x[i + 5], 12, 1200080426);
            c = md5_ff(c, d, a, b, x[i + 6], 17, -1473231341);
            b = md5_ff(b, c, d, a, x[i + 7], 22, -45705983);
            a = md5_ff(a, b, c, d, x[i + 8], 7, 1770035416);
            d = md5_ff(d, a, b, c, x[i + 9], 12, -1958414417);
            c = md5_ff(c, d, a, b, x[i + 10], 17, -42063);
            b = md5_ff(b, c, d, a, x[i + 11], 22, -1990404162);
            a = md5_ff(a, b, c, d, x[i + 12], 7, 1804603682);
            d = md5_ff(d, a, b, c, x[i + 13], 12, -40341101);
            c = md5_ff(c, d, a, b, x[i + 14], 17, -1502002290);
            b = md5_ff(b, c, d, a, x[i + 15], 22, 1236535329);
            a = md5_gg(a, b, c, d, x[i + 1], 5, -165796510);
            d = md5_gg(d, a, b, c, x[i + 6], 9, -1069501632);
            c = md5_gg(c, d, a, b, x[i + 11], 14, 643717713);
            b = md5_gg(b, c, d, a, x[i + 0], 20, -373897302);
            a = md5_gg(a, b, c, d, x[i + 5], 5, -701558691);
            d = md5_gg(d, a, b, c, x[i + 10], 9, 38016083);
            c = md5_gg(c, d, a, b, x[i + 15], 14, -660478335);
            b = md5_gg(b, c, d, a, x[i + 4], 20, -405537848);
            a = md5_gg(a, b, c, d, x[i + 9], 5, 568446438);
            d = md5_gg(d, a, b, c, x[i + 14], 9, -1019803690);
            c = md5_gg(c, d, a, b, x[i + 3], 14, -187363961);
            b = md5_gg(b, c, d, a, x[i + 8], 20, 1163531501);
            a = md5_gg(a, b, c, d, x[i + 13], 5, -1444681467);
            d = md5_gg(d, a, b, c, x[i + 2], 9, -51403784);
            c = md5_gg(c, d, a, b, x[i + 7], 14, 1735328473);
            b = md5_gg(b, c, d, a, x[i + 12], 20, -1926607734);
            a = md5_hh(a, b, c, d, x[i + 5], 4, -378558);
            d = md5_hh(d, a, b, c, x[i + 8], 11, -2022574463);
            c = md5_hh(c, d, a, b, x[i + 11], 16, 1839030562);
            b = md5_hh(b, c, d, a, x[i + 14], 23, -35309556);
            a = md5_hh(a, b, c, d, x[i + 1], 4, -1530992060);
            d = md5_hh(d, a, b, c, x[i + 4], 11, 1272893353);
            c = md5_hh(c, d, a, b, x[i + 7], 16, -155497632);
            b = md5_hh(b, c, d, a, x[i + 10], 23, -1094730640);
            a = md5_hh(a, b, c, d, x[i + 13], 4, 681279174);
            d = md5_hh(d, a, b, c, x[i + 0], 11, -358537222);
            c = md5_hh(c, d, a, b, x[i + 3], 16, -722521979);
            b = md5_hh(b, c, d, a, x[i + 6], 23, 76029189);
            a = md5_hh(a, b, c, d, x[i + 9], 4, -640364487);
            d = md5_hh(d, a, b, c, x[i + 12], 11, -421815835);
            c = md5_hh(c, d, a, b, x[i + 15], 16, 530742520);
            b = md5_hh(b, c, d, a, x[i + 2], 23, -995338651);
            a = md5_ii(a, b, c, d, x[i + 0], 6, -198630844);
            d = md5_ii(d, a, b, c, x[i + 7], 10, 1126891415);
            c = md5_ii(c, d, a, b, x[i + 14], 15, -1416354905);
            b = md5_ii(b, c, d, a, x[i + 5], 21, -57434055);
            a = md5_ii(a, b, c, d, x[i + 12], 6, 1700485571);
            d = md5_ii(d, a, b, c, x[i + 3], 10, -1894986606);
            c = md5_ii(c, d, a, b, x[i + 10], 15, -1051523);
            b = md5_ii(b, c, d, a, x[i + 1], 21, -2054922799);
            a = md5_ii(a, b, c, d, x[i + 8], 6, 1873313359);
            d = md5_ii(d, a, b, c, x[i + 15], 10, -30611744);
            c = md5_ii(c, d, a, b, x[i + 6], 15, -1560198380);
            b = md5_ii(b, c, d, a, x[i + 13], 21, 1309151649);
            a = md5_ii(a, b, c, d, x[i + 4], 6, -145523070);
            d = md5_ii(d, a, b, c, x[i + 11], 10, -1120210379);
            c = md5_ii(c, d, a, b, x[i + 2], 15, 718787259);
            b = md5_ii(b, c, d, a, x[i + 9], 21, -343485551);
            a = safe_add(a, olda);
            b = safe_add(b, oldb);
            c = safe_add(c, oldc);
            d = safe_add(d, oldd)
        }
        if (mode == 16) {
            return Array(b, c)
        } else {
            return Array(a, b, c, d)
        }
    }
    function md5_cmn(q, a, b, x, s, t) {
        return safe_add(bit_rol(safe_add(safe_add(a, q), safe_add(x, t)), s), b)
    }
    function md5_ff(a, b, c, d, x, s, t) {
        return md5_cmn((b & c) | ((~b) & d), a, b, x, s, t)
    }
    function md5_gg(a, b, c, d, x, s, t) {
        return md5_cmn((b & d) | (c & (~d)), a, b, x, s, t)
    }
    function md5_hh(a, b, c, d, x, s, t) {
        return md5_cmn(b ^ c ^ d, a, b, x, s, t)
    }
    function md5_ii(a, b, c, d, x, s, t) {
        return md5_cmn(c ^ (b | (~d)), a, b, x, s, t)
    }
    function core_hmac_md5(key, data) {
        var bkey = str2binl(key);
        if (bkey.length > 16) {
            bkey = core_md5(bkey, key.length * chrsz)
        }
        var ipad = Array(16),
        opad = Array(16);
        for (var i = 0; i < 16; i++) {
            ipad[i] = bkey[i] ^ 909522486;
            opad[i] = bkey[i] ^ 1549556828
        }
        var hash = core_md5(ipad.concat(str2binl(data)), 512 + data.length * chrsz);
        return core_md5(opad.concat(hash), 512 + 128)
    }
    function safe_add(x, y) {
        var lsw = (x & 65535) + (y & 65535);
        var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
        return (msw << 16) | (lsw & 65535)
    }
    function bit_rol(num, cnt) {
        return (num << cnt) | (num >>> (32 - cnt))
    }
    function str2binl(str) {
        var bin = Array();
        var mask = (1 << chrsz) - 1;
        for (var i = 0; i < str.length * chrsz; i += chrsz) {
            bin[i >> 5] |= (str.charCodeAt(i / chrsz) & mask) << (i % 32)
        }
        return bin
    }
    function binl2str(bin) {
        var str = "";
        var mask = (1 << chrsz) - 1;
        for (var i = 0; i < bin.length * 32; i += chrsz) {
            str += String.fromCharCode((bin[i >> 5] >>> (i % 32)) & mask)
        }
        return str
    }
    function binl2hex(binarray) {
        var hex_tab = hexcase ? "0123456789ABCDEF": "0123456789abcdef";
        var str = "";
        for (var i = 0; i < binarray.length * 4; i++) {
            str += hex_tab.charAt((binarray[i >> 2] >> ((i % 4) * 8 + 4)) & 15) + hex_tab.charAt((binarray[i >> 2] >> ((i % 4) * 8)) & 15)
        }
        return str
    }
    function binl2b64(binarray) {
        var tab = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        var str = "";
        for (var i = 0; i < binarray.length * 4; i += 3) {
            var triplet = (((binarray[i >> 2] >> 8 * (i % 4)) & 255) << 16) | (((binarray[i + 1 >> 2] >> 8 * ((i + 1) % 4)) & 255) << 8) | ((binarray[i + 2 >> 2] >> 8 * ((i + 2) % 4)) & 255);
            for (var j = 0; j < 4; j++) {
                if (i * 8 + j * 6 > binarray.length * 32) {
                    str += b64pad
                } else {
                    str += tab.charAt((triplet >> 6 * (3 - j)) & 63)
                }
            }
        }
        return str
    }
    function hexchar2bin(str) {
        var arr = [];
        for (var i = 0; i < str.length; i = i + 2) {
            arr.push("\\x" + str.substr(i, 2))
        }
        arr = arr.join("");
        eval("var temp = '" + arr + "'");
        return temp
    }
    function __monitor(mid, probability) {
        if (Math.random() > (probability || 1)) {
            return
        }
        try {
            var url = location.protocol + "//ui.ptlogin2.qq.com/cgi-bin/report?id=" + mid;
            var s = document.createElement("img");
            s.src = url
        } catch(e) {}
    }
    function getEncryption(password, salt, vcode, isMd5) {
        vcode = vcode || "";
        password = password || "";

        // md5加密
        var md5Pwd = isMd5 ? password: md5(password),

        // 将md5转换为bin格式：\xff
        h1 = hexchar2bin(md5Pwd),

        // 加盐md5
        s2 = md5(h1 + salt),


        rsaH1 = RSA.rsa_encrypt(h1),
        rsaH1Len = (rsaH1.length / 2).toString(16),
        hexVcode = TEA.strToBytes(vcode.toUpperCase(), true),
        vcodeLen = Number(hexVcode.length / 2).toString(16);

        while (vcodeLen.length < 4) {
            vcodeLen = "0" + vcodeLen
        }
        while (rsaH1Len.length < 4) {
            rsaH1Len = "0" + rsaH1Len
        }
        TEA.initkey(s2);
        var saltPwd = TEA.enAsBase64(rsaH1Len + rsaH1 + TEA.strToBytes(salt) + vcodeLen + hexVcode);
        TEA.initkey("");

        // setTimeout(function() {
        //     __monitor(488358, 1)
        // },
        // 0);
        return saltPwd.replace(/[\/\+=]/g,
        function(a) {
            return {
                "/": "-",
                "+": "*",
                "=": "_"
            } [a]
        })
    }
    function getRSAEncryption(password, vcode, isMd5) {
        var str1 = isMd5 ? password: md5(password);
        var str2 = str1 + vcode.toUpperCase();
        var str3 = $.RSA.rsa_encrypt(str2);
        return str3
    }
    return {
        getEncryption: getEncryption,
        getRSAEncryption: getRSAEncryption,
        md5: md5
    }
} ();

// var encrypted = RSA.rsa_encrypt('hello');
// console.log('rsa_encrypt: ' + encrypted);
//
// console.log('strToBytes("abcdef"): ' + TEA.strToBytes('abcdef'));
//
// console.log('initkey("abcedf"): ' + TEA.initkey('abcdef'));
//
// console.log('enAsBase64("abcdefghijk")', TEA.enAsBase64('abcdefhijk'));
//
// var pass = 'LIshang(@!)@&';
// var salt = 'Npw';
// var verifyCode = 'tcac';
//
// console.log(Encryption.getEncryption(pass, salt, verifyCode))
module.exports = Encryption.getEncryption;
