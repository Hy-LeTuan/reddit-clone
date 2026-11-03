module Web.View.Users.Show where
import Web.View.Prelude

data ShowView = ShowView { user :: User }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>Show User</h1>
        <dl>
            <dt>Handle</dt><dd>{user.handle}</dd>
            <dt>Display</dt><dd>{user.display}</dd>
            <dt>Email</dt><dd>{user.email}</dd>
            <dt>Password Hash</dt><dd>{user.passwordHash}</dd>
            <dt>Failed Login Attempts</dt><dd>{user.failedLoginAttempts}</dd>
        </dl>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Users" UsersAction
                            , breadcrumbText "Show User"
                            ]