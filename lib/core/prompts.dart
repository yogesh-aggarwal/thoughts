const STORY_PROMPT =
    'This is a app let users record their thoughts and feelings all day whenever they want. Users often like to see a "diaried" version of their thougts. Basically, they have their thoughts recorded as notes, they want to see a "diary" version of their thoughts. So following are the thoughts of the users: \n---\n\n%THOUGHTS%\n\n---\n Write a diared version of the above thoughts. Make sure it look like written by a human from deep heart. Do not exagerate the feelings. Just write a simple diary version of the thoughts. Do not write anything else other than the diary version of the thoughts. Adapt the user\'s writing style only. Do not include any time stamps. The diary must be in paras only. DO NOT MAKE UP ANYTHING BY YOURSELF AT ALL. \n\n---\nDiary version of the thoughts:\n\n---\n\n';