#ifndef MUFFINDEFINITION_H_INCLUDED
#define MUFFINDEFINITION_H_INCLUDED

#include <string>
#include <vector>
#include "Muffin/TokenHolder.h"
#include "Thing/Blocks/ThingBlock.h"

namespace PonykartParsers
{
// Represents a .muffin file
class MuffinDefinition : public TokenHolder // TODO: Implement this class and TokenHolder properly
{
public:
	MuffinDefinition(std::string Name);
	void finish() override;
	// Getters
	std::string getName();
public:
	std::vector<ThingBlock> thingBlocks;
	std::vector<std::string> extraFiles; // Other .muffin files this one should load.
private: // Set-private public members
	std::string name;
};
} // PonykartParsers

#endif // MUFFINDEFINITION_H_INCLUDED
