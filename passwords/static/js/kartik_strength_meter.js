// from https://github.com/kartik-v/strength-meter/blob/master/js/strength-meter.js

"use strict";

String.prototype.strReverse = function () {
    var newstring = "";
    for (var s = 0; s < this.length; s++) {
        newstring = this.charAt(s) + newstring;
    }
    return newstring;
};

var Strength = {
    rules: {
        minLength: 2,
        midChar: 2,
        consecAlphaUC: 2,
        consecAlphaLC: 2,
        consecNumber: 2,
        seqAlpha: 3,
        seqNumber: 3,
        seqSymbol: 3,
        length: 4,
        number: 4,
        symbol: 6
    },
    verdictTitles: {
        0: 'Too Short',
        1: 'Very Weak',
        2: 'Weak',
        3: 'Good',
        4: 'Strong',
        5: 'Very Strong'
    },
    getStrength: function (password) {
        var globalScore = this.getGlobalScore(password);
        var score = this.getScore(globalScore);
        var verdict = this.verdictTitles[score];
        return {
            "password": password,
            "percent": globalScore,
            "score": score,
            "verdict": verdict
        }
    },
    // determine le score simplifié qui est aussi l'index du verdict
    getScore: function (nScore) {
        if (nScore <= 80) {
            return nScore <= 0 ? 0 : Math.ceil(nScore / 20);
        }
        return 5;
    },
    // the main scoring algorithm - calculates score based on entered password text
    getGlobalScore: function (text) {
        var rules = this.rules;
        if (Strength.isEmpty(text) || text.length < rules.minLength) {
            return 0;
        }
        var nAlphaUC = 0, nAlphaLC = 0, nNumber = 0, nSymbol = 0, nMidChar = 0, nUnqChar = 0, nRepChar = 0,
            nRepInc = 0, nConsecAlphaUC = 0, nConsecAlphaLC = 0, nConsecNumber = 0, nConsecSymbol = 0,
            nConsecCharType = 0, nSeqAlpha = 0, nSeqNumber = 0, nSeqSymbol = 0, nSeqChar = 0,
            nMultMidChar = rules.midChar, nMultConsecAlphaUC = rules.consecAlphaUC,
            nMultConsecAlphaLC = rules.consecAlphaLC, nMultConsecNumber = rules.consecNumber,
            nMultSeqAlpha = rules.seqAlpha, nMultSeqNumber = rules.seqNumber, nMultSeqSymbol = rules.seqSymbol,
            nMultLength = rules.length, nMultNumber = rules.number, nMultSymbol = rules.symbol,
            nTmpAlphaUC = -1, nTmpAlphaLC = -1, nTmpNumber = "", nTmpSymbol = "",
            sAlphas = "abcdefghijklmnopqrstuvwxyz", sNumerics = "01234567890", sSymbols = ")!@#$%^&*()",
            nScore = text.length * nMultLength, nLength = text.length, s, sFwd, sRev, str = '', a, b, bCharExists,
            arrPwd = text.replace(/\s+/g, "").split(/\s*/), arrPwdLen = arrPwd.length;

        // loop through password to check for Symbol, Numeric, Lowercase and Uppercase pattern matches
        for (a = 0; a < arrPwdLen; a++) {
            str = arrPwd[a];
            if (str.toUpperCase() !== str) {
                if (nTmpAlphaUC !== -1 && (nTmpAlphaUC + 1) === a) {
                    nConsecAlphaUC++;
                    nConsecCharType++;
                }
                nTmpAlphaUC = a;
                nAlphaUC++;
                break;
            }
            else {
                if (str.toLowerCase() !== str) {
                    if (nTmpAlphaLC !== -1 && (nTmpAlphaLC + 1) === a) {
                        nConsecAlphaLC++;
                        nConsecCharType++;
                    }
                    nTmpAlphaLC = a;
                    nAlphaLC++;
                } else {
                    if (str.match(/[0-9]/g)) {
                        if (a > 0 && a < (arrPwdLen - 1)) {
                            nMidChar++;
                        }
                        if (nTmpNumber !== "" && (nTmpNumber + 1) === a) {
                            nConsecNumber++;
                            nConsecCharType++;
                        }
                        nTmpNumber = a;
                        nNumber++;
                    } else {
                        if (str.match(/[^\w]/g)) {
                            if (a > 0 && a < (arrPwdLen - 1)) {
                                nMidChar++;
                            }
                            if (nTmpSymbol !== "" && (nTmpSymbol + 1) === a) {
                                nConsecSymbol++;
                                nConsecCharType++;
                            }
                            nTmpSymbol = a;
                            nSymbol++;
                        }
                    }
                }
            }
            // internal loop through password to check for repeat characters
            bCharExists = false;
            for (b = 0; b < arrPwdLen; b++) {
                if (arrPwd[a] === arrPwd[b] && a !== b) { // repeat character exists
                    bCharExists = true;
                    /*
                     Calculate increment deduction based on proximity to identical characters
                     Deduction is incremented each time a new match is discovered
                     Deduction amount is based on total password length divided by the
                     difference of distance between currently selected match
                     */
                    nRepInc += Math.abs(arrPwdLen / (b - a));
                }
            }
            if (bCharExists) {
                nRepChar++;
                nUnqChar = arrPwdLen - nRepChar;
                nRepInc = (nUnqChar) ? Math.ceil(nRepInc / nUnqChar) : Math.ceil(nRepInc);
            }
        }

        // check for sequential alpha string patterns (forward and reverse)
        for (s = 0; s < 23; s++) {
            sFwd = sAlphas.substring(s, s + 3);
            sRev = sFwd.strReverse();
            if (text.toLowerCase().indexOf(sFwd) !== -1 || text.toLowerCase().indexOf(sRev) !== -1) {
                nSeqAlpha++;
                nSeqChar++;
            }
        }

        // check for sequential numeric string patterns (forward and reverse)
        for (s = 0; s < 8; s++) {
            sFwd = sNumerics.substring(s, s + 3);
            sRev = sFwd.strReverse();
            if (text.toLowerCase().indexOf(sFwd) !== -1 || text.toLowerCase().indexOf(sRev) !== -1) {
                nSeqNumber++;
                nSeqChar++;
            }
        }

        // check for sequential symbol string patterns (forward and reverse)
        for (s = 0; s < 8; s++) {
            sFwd = sSymbols.substring(s, s + 3);
            sRev = sFwd.strReverse();
            if (text.toLowerCase().indexOf(sFwd) !== -1 || text.toLowerCase().indexOf(sRev) !== -1) {
                nSeqSymbol++;
                nSeqChar++;
            }
        }

        /**
         * modify overall score value based on usage vs requirements
         */
        // general point assignment
        if (nAlphaUC > 0 && nAlphaUC < nLength) {
            nScore = nScore + (nLength - nAlphaUC) * 2;
        }
        if (nAlphaLC > 0 && nAlphaLC < nLength) {
            nScore = nScore + (nLength - nAlphaLC) * 2;
        }
        if (nNumber > 0 && nNumber < nLength) {
            nScore = nScore + nNumber * nMultNumber;
        }
        if (nSymbol > 0) {
            nScore = nScore + nSymbol * nMultSymbol;
        }
        if (nMidChar > 0) {
            nScore = nScore + nMidChar * nMultMidChar;
        }

        // point deductions for poor practices
        if ((nAlphaLC > 0 || nAlphaUC > 0) && nSymbol === 0 && nNumber === 0) {  // Only Letters
            nScore = nScore - nLength;
        }
        if (nAlphaLC === 0 && nAlphaUC === 0 && nSymbol === 0 && nNumber > 0) {  // Only Numbers
            nScore = nScore - nLength;
        }
        if (nRepChar > 0) {  // Same character exists more than once
            nScore = nScore - nRepInc;
        }
        if (nConsecAlphaUC > 0) {  // Consecutive Uppercase Letters exist
            nScore = nScore - nConsecAlphaUC * nMultConsecAlphaUC;
        }
        if (nConsecAlphaLC > 0) {  // Consecutive Lowercase Letters exist
            nScore = nScore - nConsecAlphaLC * nMultConsecAlphaLC;
        }
        if (nConsecNumber > 0) {  // Consecutive Numbers exist
            nScore = nScore - nConsecNumber * nMultConsecNumber;
        }
        if (nSeqAlpha > 0) {  // Sequential alpha strings exist (3 characters or more)
            nScore = nScore - nSeqAlpha * nMultSeqAlpha;
        }
        if (nSeqNumber > 0) {  // Sequential numeric strings exist (3 characters or more)
            nScore = nScore - nSeqNumber * nMultSeqNumber;
        }
        if (nSeqSymbol > 0) {  // Sequential symbol strings exist (3 characters or more)
            nScore = nScore - nSeqSymbol * nMultSeqSymbol;
        }
        nScore = nScore <= 0 ? (nLength >= nMultLength ? 1 : 0) : Math.min(nScore, 100);
        return nScore;
    },
    isEmpty: function (value, trim) {
        return value === null || value === undefined || value.length === 0 || trim && value.trim() === '';
    }
};
