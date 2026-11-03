module Web.Types where

import IHP.LoginSupport.Types
import IHP.Prelude
import IHP.ModelSupport
import Generated.Types

data WebApplication = WebApplication deriving (Eq, Show)


data StaticController = WelcomeAction deriving (Eq, Show, Data)

instance HasNewSessionUrl User where
    newSessionUrl _ = "/NewSession"

type instance CurrentUserRecord = User

data SessionsController
    = NewSessionAction
    | CreateSessionAction
    | DeleteSessionAction
    deriving (Eq, Show, Data)

data PostsController
    = PostsAction
    | NewPostAction
    | ShowPostAction { postId :: !(Id Post) }
    | CreatePostAction
    | EditPostAction { postId :: !(Id Post) }
    | UpdatePostAction { postId :: !(Id Post) }
    | UpdateReactionForPostAction { postId :: !(Id Post), positive :: !Bool }
    | DeletePostAction { postId :: !(Id Post) }
    deriving (Eq, Show, Data)

data SubredditsController
    = SubredditsAction
    | NewSubredditAction
    | ShowSubredditAction { subredditId :: !(Id Subreddit) }
    | CreateSubredditAction
    | EditSubredditAction { subredditId :: !(Id Subreddit) }
    | UpdateSubredditAction { subredditId :: !(Id Subreddit) }
    | DeleteSubredditAction { subredditId :: !(Id Subreddit) }
    deriving (Eq, Show, Data)

data UsersController
    = UsersAction
    | NewUserAction
    | ShowUserAction { userId :: !(Id User) }
    | CreateUserAction
    | EditUserAction { userId :: !(Id User) }
    | UpdateUserAction { userId :: !(Id User) }
    | DeleteUserAction { userId :: !(Id User) }
    deriving (Eq, Show, Data)

data CommentsController
    = CommentsAction
    | NewCommentAction { userId :: !(Id User), postId :: !(Id Post) }
    | ShowCommentAction { commentId :: !(Id Comment) }
    | CreateCommentAction
    | EditCommentAction { commentId :: !(Id Comment) }
    | UpdateCommentAction { commentId :: !(Id Comment) }
    | DeleteCommentAction { commentId :: !(Id Comment) }
    deriving (Eq, Show, Data)

data PostWithRecords = PostWithRecords {
    post :: !(Include "subredditId" (Include "userId" Post)),
    roots :: ![Comment],
    replies :: ![Comment],
    commentUsers :: ![User]
    } deriving (Show)

data UserReactionsController
    = UserReactionsAction
    | NewUserReactionAction
    | ShowUserReactionAction { userReactionId :: !(Id UserReaction) }
    | CreateUserReactionAction
    | EditUserReactionAction { userReactionId :: !(Id UserReaction) }
    | UpdateUserReactionAction { userReactionId :: !(Id UserReaction) }
    | DeleteUserReactionAction { userReactionId :: !(Id UserReaction) }
    deriving (Eq, Show, Data)
