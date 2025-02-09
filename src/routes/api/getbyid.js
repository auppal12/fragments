const { Fragment } = require('../../model/fragment');
const { createSuccessResponse, createErrorResponse } = require('../../response');
const logger = require('../../logger');

/**
 * Get a fragment by its ID
 */
module.exports = async (req, res) => {
    try {
        const { id } = req.params;
        const userId = req.user;

        logger.debug({ userId, fragmentId: id }, 'Getting fragment by id');

        // Get the fragment by ID
        const fragment = await Fragment.byId(userId, id);

        logger.info({ userId, fragmentId: id }, 'Fragment retrieved successfully');

        res.status(200).json(createSuccessResponse({ fragment }));
    } catch (error) {
        logger.error({ error, userId: req.user, fragmentId: req.params.id }, 'Unable to get fragment by id');
        res.status(500).json(createErrorResponse(500, error.message));
    }
};