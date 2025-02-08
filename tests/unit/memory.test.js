const {
    writeFragment,
    readFragment,
    writeFragmentData,
    readFragmentData,
    deleteFragment,
} = require('../../src/model/data/memory');

describe('MemoryDB Fragment Tests', () => {
    let ownerId, fragment;

    beforeEach(() => {
        ownerId = 'user123';
        fragment = {
            id: 'fragment1',
            ownerId,
            type: 'text/plain',
            size: 100,
        };
    });

    test('writeFragment should store fragment metadata', async () => {
        await writeFragment(fragment);
        const storedFragment = await readFragment(ownerId, fragment.id);
        expect(storedFragment).toEqual(fragment);
    });

    test('readFragment should return null or undefined for non-existing fragment', async () => {
        const storedFragment = await readFragment(ownerId, 'nonexistent');
        expect(storedFragment).toBeFalsy(); // Handles both null and undefined
    });

    test('writeFragmentData should store fragment data', async () => {
        const buffer = Buffer.from('Hello, world!');
        await writeFragmentData(ownerId, fragment.id, buffer);
        const storedData = await readFragmentData(ownerId, fragment.id);
        expect(storedData).toEqual(buffer);
    });

    test('readFragmentData should return null or undefined for non-existing data', async () => {
        const storedData = await readFragmentData(ownerId, 'nonexistent');
        expect(storedData).toBeFalsy(); // Handles both null and undefined
    });

    test('deleteFragment should remove metadata and data', async () => {
        const buffer = Buffer.from('Test Data');
        await writeFragment(fragment);
        await writeFragmentData(ownerId, fragment.id, buffer);
        await deleteFragment(ownerId, fragment.id);

        const storedFragment = await readFragment(ownerId, fragment.id);
        const storedData = await readFragmentData(ownerId, fragment.id);
        expect(storedFragment).toBeFalsy(); // Handles both null and undefined
        expect(storedData).toBeFalsy(); // Handles both null and undefined
    });
});

