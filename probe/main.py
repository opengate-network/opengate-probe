import os
import subprocess
import json
from speedtest import get_complete_results

if __name__ == '__main__':
    results = []

    route_out: str = subprocess.check_output('ip r', shell=True)
    route_list = str(route_out, 'UTF-8').split('\n')

    eth_route = ""
    wifi_route = ""
    for route in route_list:
        if "default" in route:
            if "wlp1s0" in route:
                wifi_route = route
            elif "eth0" in route:
                eth_route = route

    print(f"Route found : \nwifi: {wifi_route}\neth: {eth_route}")

    if eth_route != "":
        os.system('ip r del ' + wifi_route)
        os.system('ip r flush cache')
        results.append(get_complete_results(network_type="ethernet"))
        os.system('ip r add ' + wifi_route)
        os.system('ip r flush cache')

    if wifi_route != "":
        os.system('ip r del ' + eth_route)
        os.system('ip r flush cache')
        results.append(get_complete_results(network_type="wifi"))
        os.system('ip r add ' + eth_route)
        os.system('ip r flush cache')

    json_results = json.dumps(results, indent=4)

    with open("/results.json", "w") as outfile:
        outfile.write(json_results)
