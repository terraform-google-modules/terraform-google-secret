import argparse
import warnings

from googleapiclient.discovery import build
from oauth2client.service_account import ServiceAccountCredentials


def create_parser():
    """
    Function to parse and return arguments passed in.
    """
    parser = argparse.ArgumentParser(
        description='Delete the default compute service account.'
    )
    parser.add_argument('--project_id', help='Your Google Cloud project ID.')
    parser.add_argument('--path', help='Credentials path.')

    return parser


class IdentityAccessManagementAPI(object):
    """
    Wrapper for interacting with the Google Identity and Access Management
    (IAM) API - the 'iam' service, at version 'v1'.

    Attributes:
        path: The credentials path.
        http: The HttpMockSequence to simulates the iam api responses only to
              testing.
    """

    service = None
    scopes = [
        'https://www.googleapis.com/auth/cloud-platform',
    ]

    def __init__(self, credentials_path=None, http=None):
        # Build a service object for the API using the Credentials.
        self.create_service(credentials_path, http)

    def create_service(self, credentials_path=None, http=None):
        credentials = None

        if not credentials_path:
            msg = 'Argument [credentials_path] parameter is required.'
            raise Exception(msg)

        if http is None:
            credentials = ServiceAccountCredentials.from_json_keyfile_name(credentials_path, self.scopes)

        self.service = build(
            serviceName='iam',
            version='v1',
            http=http,
            credentials=credentials)

    def get_service_account_list(self, project_name=None):
        response = self.service.projects().serviceAccounts().list(
            name=project_name).execute()
        return response

    def delete_service_account(self, service_account_name=None):
        response = self.service.projects().serviceAccounts(). \
            delete(name=service_account_name).execute()
        return response

    def delete_default_service_account(self, project_id=None,
                                       account_display_name=None, crm_api=None):
        # Remove the default compute service account and the policy generated
        # after the enable the compute api.
        if project_id is None or crm_api is None:
            msg = 'Argument [project_id] or [crm_api] parameter required'
            raise Exception(msg)

        project_name = 'projects/{0}'.format(project_id)
        sa_list = self.get_service_account_list(project_name=project_name)

        sa_to_delete = None

        for account in sa_list.get('accounts', []):

            if account_display_name == account.get('displayName'):
                email = account.get('email')

                sa_to_delete = '{0}/serviceAccounts/{1}' \
                    .format(project_name, email)

                crm_api.delete_compute_default_member(project_id=project_id, email=email)
                break

        if not sa_to_delete:
            msg = '*** Service account with display name [{0}] not founded ***'\
                .format(account_display_name)
            warnings.warn(msg)
            return

        response = self.delete_service_account(
            service_account_name=sa_to_delete)

        return response


class CloudResourceManagerAPI(object):
    """
    Wrapper for interacting with the Google Cloud Resource Manager API.

    Attributes:
        path: The credentials path.
        http: The HttpMockSequence to simulates the iam api responses only to
              testing.
    """
    service = None
    scopes = [
        'https://www.googleapis.com/auth/cloud-platform'
    ]

    def __init__(self, credentials_path=None, http=None):
        # Build a service object for the API using the Credentials.
        self.create_service(credentials_path, http)

    def create_service(self, credentials_path=None, http=None):
        credentials = None

        if not credentials_path:
            msg = 'Argument [credentials_path] parameter is required.'
            raise Exception(msg)

        if http is None:
            credentials = ServiceAccountCredentials.from_json_keyfile_name(credentials_path, self.scopes)

        self.service = build(
            serviceName='cloudresourcemanager',
            version='v1',
            http=http,
            credentials=credentials)

    def get_iam_policy(self, project_id=None, body={}):
        response = self.service.projects().getIamPolicy(
            resource=project_id,
            body=body).execute()

        return response

    def set_iam_policy(self, project_id=None, body={}):
        response = self.service.projects().setIamPolicy(
            resource=project_id,
            body=body).execute()
        return response

    def delete_compute_default_member(self, project_id=None, email=None):
        # To delete a member we need get and update the policy.
        iam_policy = self.get_iam_policy(project_id=project_id)

        sa_iam_path = 'serviceAccount:{0}'.format(email)
        policy_found = False

        for binding in iam_policy.get('bindings'):
            members = binding.get('members', [])

            if sa_iam_path in members:
                members.remove(sa_iam_path)
                policy_found = True
                break

        if not policy_found:
            warnings.warn(
                '*** iam policy with service account path [{0}] not founded ***'
                    .format(sa_iam_path))
            return

        iam_policy.pop('etag')
        iam_policy.pop('version')

        response = self.set_iam_policy(
            project_id=project_id,
            body={'policy': iam_policy}
        )

        return response


def main():
    parser = create_parser()
    args = parser.parse_args()

    iam_api = IdentityAccessManagementAPI(credentials_path=args.path)
    iam_api.delete_default_service_account(
        project_id=args.project_id,
        account_display_name='Compute Engine default service account',
        crm_api=CloudResourceManagerAPI(credentials_path=args.path),
    )


if __name__ == '__main__':
    main()
