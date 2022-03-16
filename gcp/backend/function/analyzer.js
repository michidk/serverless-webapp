function countRegex(input, regex) {
    let reg = input.match(regex);
    return reg != null ? reg.length : 0;
}

function countVowels(input) {
    return countRegex(input, /[aeiou]/gi);
}

function countNumbers(input) {
    return countRegex(input, /[0-9]/g);
}

function countSpecial(input) {
    return countRegex(input, /[@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?!]/g);
}

function countWords(input) {
    return input.split(' ')
        .filter(function (n) { return n != '' })
        .length;
}

function countSentences(input) {
    return countRegex(input, /[^?!.][?!.]/g);
}

function mostFrequentWord(input) {
    let words = input.split(' ').filter(function (n) { return n != '' && n.length > 1 });
    if (words.length == 1) {
        return words[0];
    } else if (words.length == 0) {
        return "";
    }

    let counts = {};

    // count words
    for (let i = 0; i < words.length; i++) {
        let word = words[i].toLowerCase();
        if (word in counts) {
            counts[word] += 1;
        } else {
            counts[word] = 0;
        }
    }

    // find entry with highest value
    return Object.keys(counts).reduce((a, b) => counts[a] > counts[b] ? a : b);
}

export function analyze(input) {
    if (input == null) input = "";

    let data = JSON.stringify({
        length: input.length,
        vowels: countVowels(input),
        numbers: countNumbers(input),
        special: countSpecial(input),
        words: countWords(input),
        sentences: countSentences(input),
        mostFrequentWord: mostFrequentWord(input)
    });

    return {
        success: true,
        data
    }
}
