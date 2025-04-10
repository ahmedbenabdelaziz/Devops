const Overtime = require('../models/Overtime');

// Fonction pour récupérer les heures supplémentaires
exports.getOvertime = async (req, res) => {
  try {
    const overtime = await Overtime.findAll({ where: { employeeId: req.params.employeeId } });
    res.json(overtime);
  } catch (error) {
    res.status(500).json({ message: 'Erreur lors de la récupération des heures supplémentaires', error });
  }
};
