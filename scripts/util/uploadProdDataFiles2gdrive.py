################################################################
# Author - Colathur Vijayan [VJN]
# In a loop this script will upload files to Google Drive.
################################################################

from __future__ import print_function

import os
import sys
import glob
import json
import subprocess
import hashlib

from apiclient.http import MediaFileUpload
from api_boilerplate import file_service

def create_file(file_path, parentId=None):
    """
    Creates a new file on the Drive.
    :param file_path: The path of the source file on local storage.
    :type file_path: str
    :param parentId: The ID of the directory in which the file has to be
    created. If it is None, the file will be created in the root directory.
    :type parentId: str or None
    :returns: A dictionary containing the ID of the file created.
    """
    file_name = os.path.basename(file_path)

    mimetype = None
    if not os.path.splitext(file_name)[1]:
        mimetype = "text/plain"

    media_body = MediaFileUpload(file_path, mimetype=mimetype)
    body = {'name': file_name}
    if parentId:
        body['parents'] = [parentId]

    results = file_service.create(
        body=body, media_body=media_body, fields="id").execute()

    return results


def get_store_folder_id(store_code, parent_folder_id):
    """
    Gets the folder id of the store code passed in, based on its parent folder id
    """
    searchStr = "\'" + parent_folder_id + "\'" + ' in parents'
    # print (searchStr)
    # print (input_file)

    results = file_service.list(
    pageSize=10, q =  searchStr, fields="nextPageToken, files(id, name)").execute()
    items = results.get('files', [])
    x = None
    for item in items:
        if item['name'] == store_code :
            print ("Store Directory Found")
            print (item['id'])
            x = item['id']
    return x



def smart_create_file(folder_id, input_file_with_path, input_file):
    """
    Deletes the file if it exists already on the Drive and creates a new copy.
    """
    searchStr = "\'" + folder_id + "\'" + ' in parents'
    results = file_service.list(
    pageSize=10, q =  searchStr, fields="nextPageToken, files(id, name)").execute()
    items = results.get('files', [])
    for item in items:
        if item['name'] == input_file :
            print ("File Found")
            print (item['id'])
            file_service.delete(fileId = item['id']).execute()
    create_file(input_file_with_path, folder_id)
    return None


# Upload Product Data Files
f = open('./srcm_nbks_proddata_store_list.txt', 'r')
from_dir = '../proddatafiles'
destination_folder_id = '<Enter Google Drive Directory ID>'

for scode in f:
    try:
        scode = scode.rstrip('\n')
        fileName = scode + '_proddatafile.xlsx'
        print (fileName)
        fileNameWithPath = os.path.join(from_dir, fileName)
        print(fileNameWithPath)
        smart_create_file(destination_folder_id, fileNameWithPath, fileName)
        f.close

    except Exception, e:
        f.close
        print("Exception uploading Product Data Files")
        print (e)