const { createSuccessResponse, createErrorResponse } = require("../../response");
const { Fragment } = require('../../model/fragment');
const logger = require('../../logger');

/**
 * Get a list of fragments for the current user
 */
module.exports = async (req, res) => {
    try {
        logger.debug({ userId: req.user }, 'Getting fragments for user');
        
        // Get all fragments for this user
        const fragments = await Fragment.byUser(req.user);
        
        logger.debug({ userId: req.user, fragments: fragments.length }, 'Got fragments');
        
        res.status(200).json({
            ...createSuccessResponse(),
            fragments,
        });
    } catch (error) {
        logger.error({ error, userId: req.user }, 'Unable to get fragments for user');
        res.status(500).json(
            createErrorResponse(500, error.message)
        );
    }
};
