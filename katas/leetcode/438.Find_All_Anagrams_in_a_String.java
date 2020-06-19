// 438. Find All Anagrams in a String
//
// https://leetcode.com/problems/find-all-anagrams-in-a-string/
//
// Status: problem > Time Limit Exceeded

class Solution {
    public List<Integer> findAnagrams(String haystack, String needle) {
        Map<Character, Integer> lettersToFind = buildLettersToFind(needle.toCharArray(), 0, needle.length());

        List<Integer> indexes = new ArrayList<>();
        int windowLeft = 0;
        int windowRight = needle.length()-1;

        while (windowRight < haystack.length()) {
            if (isMatch(haystack, lettersToFind, windowLeft, windowRight)) {
                indexes.add(windowLeft);
            }

            windowLeft++;
            windowRight++;
        }

        return indexes;
    }

    private Map<Character, Integer> buildLettersToFind(char[] str, int start, int end) {
        Map<Character, Integer> lettersToFind = new HashMap<>();

        for (int i = start; i < end; i++) {
            lettersToFind.merge(str[i], 1, Integer::sum);
        }

        return lettersToFind;
    }

    private boolean isMatch(
        String haystack,
        Map<Character, Integer> lettersToFind,
        int leftCursor,
        int rightCursor
    ) {
        Map<Character, Integer> currentLetters = buildLettersToFind(haystack.toCharArray(), leftCursor, rightCursor+1);

        return currentLetters.equals(lettersToFind);
    }
}
