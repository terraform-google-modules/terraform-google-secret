import sys
sys.path.append('../../scripts/')

import os
import unittest

from unittest.mock import patch
from apiclient.http import HttpMockSequence
from delete_default_compute_service_account import create_parser, \
    IdentityAccessManagementAPI, CloudResourceManagerAPI


class CloudResourceManagerAPITestCase(unittest.TestCase):
    crm_http = None

    def setUp(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))

        path1 = '{0}/json/crm_discovery_document.json'.format(dir_path)
        path2 = '{0}/json/crm_get_iam_policy.json'.format(dir_path)

        with open(path1, 'rb') as file1, open(path2, 'rb') as file2:
            build_response = file1.read()
            request_data = file2.read()

        self.crm_http = HttpMockSequence([({'status': '200'}, build_response),
                                          ({'status': '200'}, request_data)])

    def mock_set_iam_policy(project_id, body):
        return body

    @patch('delete_default_compute_service_account.CloudResourceManagerAPI.'
           'set_iam_policy', side_effect=mock_set_iam_policy)
    def delete_compute_default_member(self, set_iam_policy):
        # The set_iam_policy method is replaced with the mock_set_iam_policy
        # returning the body parameter to check that the body content will be
        # correctly received.

        crm_api = CloudResourceManagerAPI(credentials_path='/my/credentials/path.json', http=self.crm_http)
        response = crm_api.update_iam_policy(
            project_id='correct-id-123',
            email='835469197146-compute@developer.gserviceaccount.com'
        )
        self.assertEqual(len(response['policy']['bindings'][0]['members']), 1)
        self.assertEqual(len(response['policy']['bindings'][1]['members']), 1)

        self.assertEqual(
            response['policy']['bindings'][0]['members'][0],
            'user:mike@example.com'
        )
        self.assertEqual(
            response['policy']['bindings'][1]['members'][0],
            'user:sean@example.com'
        )


class IdentityAccessManagementAPITestCase(unittest.TestCase):
    dir_path = None
    parser = None

    iam_http = None
    crm_http = None

    def setUp(self):
        parser = create_parser()
        self.parser = parser

        self.dir_path = os.path.dirname(os.path.realpath(__file__))

        path1 = '{0}/json/iam_discovery_document.json'.format(self.dir_path)
        path2 = '{0}/json/iam_service_accounts.json'.format(self.dir_path)
        path3 = '{0}/json/iam_delete_service_account.json'.format(self.dir_path)

        with open(path1, 'rb') as br, open(path2, 'rb') as rd1, \
                open(path3, 'rb') as rd2:
            build_response = br.read()
            request_data1 = rd1.read()
            request_data2 = rd2.read()

        self.iam_http = HttpMockSequence([({'status': '200'}, build_response),
                                          ({'status': '200'}, request_data1),
                                          ({'status': '200'}, request_data2)])


        path1 = '{0}/json/crm_discovery_document.json'.format(self.dir_path)
        path2 = '{0}/json/crm_get_iam_policy.json'.format(self.dir_path)
        path3 = '{0}/json/crm_set_iam_policy.json'.format(self.dir_path)

        with open(path1, 'rb') as br, open(path2, 'rb') as rd1, \
                open(path3, 'rb') as rd2:
            build_response = br.read()
            request_data1 = rd1.read()
            request_data2 = rd2.read()

        self.crm_http = HttpMockSequence([({'status': '200'}, build_response),
                                          ({'status': '200'}, request_data1),
                                          ({'status': '200'}, request_data2)])

    def test_delete_default_service_account_with_path_required(self):
        args = self.parser.parse_args(['--project_id', 'correct-id-123'])

        with self.assertRaises(Exception) as cm:
            iam_api = IdentityAccessManagementAPI(args.path, self.iam_http)
            iam_api.delete_default_service_account(
                project_id=args.project_id,
                account_display_name='Compute Engine default service account',
                crm_api=CloudResourceManagerAPI(args.path, self.crm_http)
            )

        self.assertEqual(
            str(cm.exception),
            'Argument [credentials_path] parameter is required.',
        )

    def test_delete_default_service_account_with_project_id_required(self):
        args = self.parser.parse_args(['--path', '/credentials/path'])

        iam_api = IdentityAccessManagementAPI(args.path, self.iam_http)

        with self.assertRaises(Exception) as cm:
            iam_api.delete_default_service_account(
                project_id=args.project_id,
                account_display_name='Compute Engine default service account',
                crm_api=CloudResourceManagerAPI(args.path, self.crm_http)
            )

        self.assertEqual(
            str(cm.exception),
            'Argument [project_id] or [crm_api] parameter required',
        )

    def mock_delete_service_account(service_account_name):
        return service_account_name

    @patch('delete_default_compute_service_account.IdentityAccessManagementAPI'
           '.delete_service_account', side_effect=mock_delete_service_account)
    def test_delete_default_service_account(self, delete_service_account):
        # The delete_service_account method is replaced with the
        # mock_set_iam_policy returning the service_account_name parameter
        # to check that the service_account_name content will be correctly received.
        args = self.parser.parse_args(
            ['--project_id', 'correct-id-123', '--path', '/credentials/path'])

        iam_api = IdentityAccessManagementAPI(args.path, self.iam_http)
        result = iam_api.delete_default_service_account(
            project_id=args.project_id,
            account_display_name='Compute Engine default service account',
            crm_api=CloudResourceManagerAPI(args.path, self.crm_http)
        )

        self.assertEqual(
            result,
            'projects/{0}/serviceAccounts/835469197146-compute'
            '@developer.gserviceaccount.com'.format(args.project_id)
        )

    def test_general_delete_default_service_account(self):
        args = self.parser.parse_args(
            ['--project_id', 'correct-id-123', '--path', '/credentials/path'])

        iam_api = IdentityAccessManagementAPI(args.path, self.iam_http)
        result = iam_api.delete_default_service_account(
            project_id=args.project_id,
            account_display_name='Compute Engine default service account',
            crm_api=CloudResourceManagerAPI(args.path, self.crm_http)
        )

        self.assertEqual(result, {})


if __name__ == "__main__":
    unittest.main()
