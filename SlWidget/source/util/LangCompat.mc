(:glance)
class ArrCompat {

    static function equals(arr1, arr2) {
        if (arr1.size() != arr2.size()) { return false; }

        for (var i = 0; i < arr1.size(); i++) {
            if (arr1[i] != arr2[i]) { return false; }
        }

        return true;
    }

    static function in(arr, item) {
        return arr.indexOf(item) != -1;
    }

    static function merge(arr1, arr2) {
        var arr = new [arr1.size() + arr2.size()];

        for (var i = 0; i < arr1.size(); i++) {
            arr[i] = arr1[i];
        }
        for (var i = 0; i < arr2.size(); i++) {
            arr[arr1.size() + i] = arr2[i];
        }

        return arr;
    }

    static function add(arr1, arr2) {
        var sum = [];
        for (var i = 0; i < arr1.size() && i < arr2.size(); i++) {
            sum.add(arr1[i] + arr2[i]);
        }
        return sum;
    }

    static function coerceGet(arr, index) {
        if (arr.size() == 0) {
            return null;
        }
        return arr[coerceIn(index, 0, arr.size() - 1)];
    }

    static function swap(arr, i, j) {
        var temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }

}

class DictCompat {

    static function hasKey(dict, key) {
        return dict != null && dict.hasKey(key) && dict[key] != null;
    }

    static function get(dict, key, defaultValue) {
        return hasKey(dict, key) ? dict[key] : defaultValue;
    }

}
