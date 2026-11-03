CREATE TABLE user_reactions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    user_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    post_id UUID NOT NULL
);
CREATE INDEX user_reactions_user_id_index ON user_reactions (user_id);
CREATE INDEX user_reactions_created_at_index ON user_reactions (created_at);
CREATE INDEX user_reactions_post_id_index ON user_reactions (post_id);
ALTER TABLE user_reactions ADD CONSTRAINT user_reactions_ref_post_id FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE NO ACTION;
ALTER TABLE user_reactions ADD CONSTRAINT user_reactions_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
