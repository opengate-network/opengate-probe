import os
import json
from speedtest import get_complete_results

if __name__ == '__main__':
    results = []

    os.system('')
    results.append(get_complete_results(network_type="ethernet"))

    os.system('')
    results.append(get_complete_results(network_type="wifi"))

    json_results = json.dumps(results, indent=4)

    with open("/results.json", "w") as outfile:
        outfile.write(json_results)
