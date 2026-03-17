We are going to finish filling out the quest information for each dungeon in @data/dungeons.lua . The basic dungeon information is correct for each dungeon already - do not change these, or the Warnings (these will be handled in a separate task).

We have completed quests for these dungeons, and they can be referenced as examples.
- Ragefire Chasm
- Wailing Caverns
- Deadmines

For this task, we will complete the quests for:
- Shadowfang Keep

1. All of the data you need should be available from Wowhead, and in particular you will find https://www.wowhead.com/classic/guide/dungeon-quests-wow-classic extremely useful. You will likely need to follow the links on each quest to get detailed information for the quest rewards and quest giver.
2. When you cannot find the information you need from a definitive source, do not guess - put a comment in the code for me to review.
3. Do not include pre-req or breadcrumb quests that lead up to actual quest that occurs in the dungeon. Ask the question - "what quest should the player have in their quest log when they enter the dungeon".
4. Do include quests that originate from items dropped in the dungeon, such as the Glowing Shard from Mutanus the Devourer. Ask the question - "what quest should the player have in their quest log after completing the dungeon".
5. The quest entries should be sorted alphabetically.
6. Some of the quest giver locations will require judgement or nuance, such as Nalpak in the caves above Wailing Caverns. This is because he technically is not in the Barrens, and does not have a coordinates position, even though he is not in the instance itself. We want to keep these tooltips short but also give the player enough information to go on when trying to track down the quest giver.
7. Do not include any class quests for now
8. If a quest spans multiple dungeons (such as the SM quest "In the Name of the Light"), then include it for each dungeon where it has an objective.
9. If a dungeon quest is for a key or raid attunement we can include it.
10. Do not include any repeatable quests for now
11. If a quest rewards items and money, then include both in the rewards.
12. If a quest starts from a quest giver inside the dungeon, then add a brief appropriate description to the tooltip describing where the NPC is in the dungeon.
13. Do not reference or search for any data from expansions, like Burning Crusade, or Wrath of the Lich King.

The schema for each quest:
- name: the exact human-friendly name of the quest
- questId: the unique id of the quest, found in the Wowhead URL
- level: the level of the quest (not the minimum level to accept it)
- side: Alliance, Horde, or Both
- prereq: true or false (does the quest have any prerequisites)
- startNpc: the exact human-friendly name of the quest giver (or item)
- startNpcId: the unique id of the NPC that provides the quest, if an NPC
- startItemId: the unique id of the item that provides the quest, if an item
- startLoc: the zone or instance where the quest giver is located, or a brief description of where the item drops
- startCoords: the coordinates of the NPC who gives the quest
- money: any monetary reward from the quest, expressed in copper (e.g. 1000 is 10s)
- rewards: a collection of any items rewarded from the quest
    - itemId: the unique id of the reward item (found in the Wowhead URL)
    - name: the exact human-friendly name of the reward item

For your data sources, you should use well-known sites such as Wowhead, icy-veins, wowdb, wowclassicdb, and classicdb
