module Web.Controller.Users where

import Web.Controller.Prelude
import Web.View.Users.Index
import Web.View.Users.New
import Web.View.Users.Edit
import Web.View.Users.Show

instance Controller UsersController where
    action UsersAction = do
        users <- query @User |> fetch
        render IndexView { .. }

    action NewUserAction = do
        let user = newRecord
        render NewView { .. }

    action ShowUserAction { userId } = do
        user <- fetch userId
        render ShowView { .. }

    action EditUserAction { userId } = do
        user <- fetch userId
        render EditView { .. }

    action UpdateUserAction { userId } = do
        user <- fetch userId
        user
            |> buildUser
            >>= ifValid \case
                Left user -> render EditView { .. }
                Right user -> do
                    user <- user |> updateRecord
                    setSuccessMessage "User updated"
                    redirectTo EditUserAction { .. }

    action CreateUserAction = do
        let user = newRecord @User
        let passwordConfirmation = param @Text "passwordConfirmation"
        user
            -- password validation here
            |> fill @'["handle", "display", "email", "passwordHash", "failedLoginAttempts"]
            |> validateField #handle nonEmpty
            |> validateField #display nonEmpty
            |> validateField #email nonEmpty
            |> validateField #email isEmail
            |> validateField #passwordHash nonEmpty
            |> validateField #passwordHash (isEqual passwordConfirmation |> withCustomErrorMessage "Passwords don't match")
            -- after this, it becomes IO model so we need to use bind instead of pipe
            |> validateIsUnique #email
            >>= ifValid \case
                Left user -> render NewView { .. }
                Right user -> do
                    hashed <- hashPassword user.passwordHash
                    user <- user
                        |> set #passwordHash hashed
                        |> createRecord
                    setSuccessMessage "You have registered successfully"
                    -- change it to (redirectToPath "/") if you don't want users view
                    redirectTo UsersAction

    action DeleteUserAction { userId } = do
        user <- fetch userId
        deleteRecord user
        setSuccessMessage "User deleted"
        redirectTo UsersAction

buildUser user = user
    |> fill @'["handle", "display", "email", "passwordHash", "failedLoginAttempts"]
    |> validateField #handle nonEmpty
    |> validateField #display nonEmpty
    |> validateField #email nonEmpty
    |> validateField #email isEmail
    |> validateField #passwordHash nonEmpty
    -- after this, it becomes IO model so we need to use bind instead of pipe
    |> validateIsUnique #email
