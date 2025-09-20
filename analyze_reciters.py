#!/usr/bin/env python3
import json
from collections import defaultdict

def analyze_reciters():
    # Read the JSON file
    with open(r'C:\Zakaria\Flutter\Islamic app\Quran-Mp3\assets\data\mp3quran.json', 'r', encoding='utf-8') as f:
        data = json.load(f)

    # Dictionary to store reciters grouped by name
    reciters_by_name = defaultdict(list)
    total_reciters = 0

    # Collect all reciters
    for reciter in data:
        if 'name' in reciter and 'rewaya' in reciter and 'id' in reciter:
            name = reciter['name']
            rewaya = reciter['rewaya']
            reciter_id = reciter['id']
            server = reciter.get('server', '')

            reciters_by_name[name].append({
                'id': reciter_id,
                'rewaya': rewaya,
                'server': server
            })
            total_reciters += 1

    # Find duplicates (names with multiple rewayas)
    duplicates = {}
    for name, reciters in reciters_by_name.items():
        if len(reciters) > 1:
            duplicates[name] = reciters

    unique_names = len(reciters_by_name)
    duplicate_names = len(duplicates)

    print(f"=== RECITER ANALYSIS REPORT ===")
    print(f"Total reciters: {total_reciters}")
    print(f"Unique names: {unique_names}")
    print(f"Names with multiple rewayas: {duplicate_names}")
    print(f"Names with single rewaya: {unique_names - duplicate_names}")
    print()

    print("=== EXAMPLES OF RECITERS WITH MULTIPLE REWAYAS ===")
    count = 0
    for name, reciters in duplicates.items():
        if count >= 10:  # Show first 10 examples
            break
        print(f"\n{count + 1}. {name}")
        print(f"   Number of different rewayas: {len(reciters)}")
        for i, reciter in enumerate(reciters, 1):
            print(f"   {i}. ID: {reciter['id']}, Rewaya: {reciter['rewaya']}")
        count += 1

    if len(duplicates) > 10:
        print(f"\n... and {len(duplicates) - 10} more reciters with multiple rewayas")

    print("\n=== TOP 5 RECITERS WITH MOST REWAYAS ===")
    sorted_duplicates = sorted(duplicates.items(), key=lambda x: len(x[1]), reverse=True)
    for i, (name, reciters) in enumerate(sorted_duplicates[:5]):
        print(f"{i + 1}. {name} - {len(reciters)} rewayas:")
        for reciter in reciters:
            print(f"   - ID {reciter['id']}: {reciter['rewaya']}")

    print("\n=== REWAYA DISTRIBUTION ===")
    rewaya_count = defaultdict(int)
    for name, reciters in reciters_by_name.items():
        for reciter in reciters:
            rewaya_count[reciter['rewaya']] += 1

    sorted_rewayas = sorted(rewaya_count.items(), key=lambda x: x[1], reverse=True)
    for rewaya, count in sorted_rewayas:
        print(f"{rewaya}: {count} reciters")

if __name__ == "__main__":
    analyze_reciters()