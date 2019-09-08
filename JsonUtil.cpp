#include <algorithm>
#include <iterator>
#include <vector>

std::vector<std::string> DeserializeArrayStrings(const std::vector<std::string> &array)
{
	std::vector<std::string> strings;
	std::transform(array.begin(), array.end(), std::back_inserter(strings),
		[](const std::string &element) -> std::string { return element; });
	return strings;
}
