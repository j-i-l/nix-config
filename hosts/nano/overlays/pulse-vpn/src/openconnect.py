#!/usr/bin/env python

import os
import logging
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
import subprocess

host = "your.vpn.server"
user = "username"
chrome_profile_dir = "/home/username/.config/chromedriver/pulsevpn"


if not os.path.exists(chrome_profile_dir):
    os.makedirs(chrome_profile_dir)

logging.basicConfig(level=logging.INFO)
chrome_options = Options()
chrome_options.add_argument("user-data-dir=" + chrome_profile_dir)

def is_dsid_valid(dsid):
    # Expiry is set to Session
    return dsid is not None and 'value' in dsid

def handle_authentication(driver):
    logging.info('User needs to authenticate.')
    wait = WebDriverWait(driver, 60)
    driver.get("https://" + host)
    return wait.until(lambda driver: driver.get_cookie("DSID"))

driver = webdriver.Chrome("chromedriver", options=chrome_options)
logging.info('Starting browser.')

dsid = driver.get_cookie("DSID")

# Check if DSID is invalid or doesn't exist and handle authentication. Perhaps this needs a revisit if the server
# starts to return 403 for invalid DSID.
if not is_dsid_valid(dsid):
    dsid = handle_authentication(driver)

driver.quit()
# Cookie doesn't seem to have an expiry set. Perhaps recycle the profile every 24-48 hours?
logging.info('DSID cookie: %s', dsid)

# Run a shell command to openconnect only if DSID is valid
if is_dsid_valid(dsid):
    logging.info('Launching openconnect.')
    subprocess.run(["sudo", "openconnect", "-C", dsid["value"], "--protocol=pulse", "-u", user, host])
else:
    logging.error('No valid DSID cookie found. Could not launch openconnect.')
