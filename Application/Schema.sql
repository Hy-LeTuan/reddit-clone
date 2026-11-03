-- Your database schema. Use the Schema Designer at http://localhost:8001/ to add some tables.
CREATE TABLE posts (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    user_id UUID NOT NULL,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    upvotes INT DEFAULT 0 NOT NULL,
    downvotes INT DEFAULT 0 NOT NULL,
    subreddit_id UUID NOT NULL
);
CREATE INDEX posts_created_at_index ON posts (created_at);
CREATE INDEX posts_user_id_index ON posts (user_id);
CREATE TABLE subreddits (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    name TEXT NOT NULL,
    description TEXT NOT NULL
);
CREATE INDEX subreddits_created_at_index ON subreddits (created_at);
CREATE INDEX posts_subreddit_id_index ON posts (subreddit_id);
CREATE TABLE users (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    handle TEXT NOT NULL UNIQUE,
    display TEXT NOT NULL,
    email TEXT NOT NULL,
    password_hash TEXT NOT NULL,
    locked_at TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    failed_login_attempts INT DEFAULT 0 NOT NULL
);
CREATE TABLE comments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    user_id UUID NOT NULL,
    post_id UUID NOT NULL,
    upvotes INT DEFAULT 0 NOT NULL,
    downvotes INT DEFAULT 0 NOT NULL,
    parent_id UUID DEFAULT NULL,
    body TEXT NOT NULL
);
CREATE INDEX comments_created_at_index ON comments (created_at);
CREATE INDEX comments_user_id_index ON comments (user_id);
CREATE INDEX comments_post_id_index ON comments (post_id);
CREATE TABLE user_reactions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    user_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    post_id UUID NOT NULL,
    upvote BOOLEAN DEFAULT false NOT NULL
);
CREATE INDEX user_reactions_user_id_index ON user_reactions (user_id);
CREATE INDEX user_reactions_created_at_index ON user_reactions (created_at);
CREATE INDEX user_reactions_post_id_index ON user_reactions (post_id);
ALTER TABLE comments ADD CONSTRAINT comments_ref_parent_id FOREIGN KEY (parent_id) REFERENCES comments (id) ON DELETE NO ACTION;
ALTER TABLE comments ADD CONSTRAINT comments_ref_post_id FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE NO ACTION;
ALTER TABLE comments ADD CONSTRAINT comments_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE posts ADD CONSTRAINT posts_ref_subreddit_id FOREIGN KEY (subreddit_id) REFERENCES subreddits (id) ON DELETE NO ACTION;
ALTER TABLE posts ADD CONSTRAINT posts_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE user_reactions ADD CONSTRAINT user_reactions_ref_post_id FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE NO ACTION;
ALTER TABLE user_reactions ADD CONSTRAINT user_reactions_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
