b = function(b, i) {
        this.s = b || 0;
        this.e = i || 0
      }

P = function(i, a) {
        var j = [];
        j[0] = i >> 24 & 255;
        j[1] = i >> 16 & 255;
        j[2] = i >> 8 & 255;
        j[3] = i & 255;
        for (var s = [], e = 0; e < a.length; ++e) s.push(a.charCodeAt(e));
        e = [];
        for (e.push(new b(0, s.length - 1)); e.length > 0;) {
          var c = e.pop();
          if (!(c.s >= c.e || c.s < 0 || c.e >= s.length))
            if (c.s + 1 == c.e) {
              if (s[c.s] > s[c.e]) {
                var J = s[c.s];
                s[c.s] = s[c.e];
                s[c.e] = J
              }
            } else {
              for (var J = c.s, l = c.e, f = s[c.s]; c.s < c.e;) {
                for (; c.s < c.e && s[c.e] >= f;) c.e--, j[0] = j[0] + 3 & 255;
                c.s < c.e && (s[c.s] = s[c.e], c.s++, j[1] = j[1] * 13 + 43 & 255);
                for (; c.s < c.e && s[c.s] <= f;) c.s++, j[2] = j[2] - 3 & 255;
                c.s < c.e && (s[c.e] = s[c.s], c.e--, j[3] = (j[0] ^ j[1] ^ j[2] ^ j[3] + 1) & 255)
              }
              s[c.s] = f;
              e.push(new b(J, c.s - 1));
              e.push(new b(c.s + 1, l))
            }
        }
        s = ["0", "1", "2", "3", "4",
          "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"
        ];
        e = "";
        for (c = 0; c < j.length; c++) e += s[j[c] >> 4 & 15], e += s[j[c] & 15];
        return e
      }

console.log( P("aaaaasdfdf","bbxxxxxff") )
      