const fs = require('fs');
const path = require('path');

// Read the TypeScript file
const tsContent = fs.readFileSync(path.join(__dirname, 'curriculum.ts'), 'utf8');

// Extract the curriculum object content
const match = tsContent.match(/export const CURRICULUM_FULL[^=]*=\s*\{([\s\S]*)\};?\s*$/);
if (!match) {
  console.error('Could not find CURRICULUM_FULL in the file');
  process.exit(1);
}

// Parse the TypeScript object manually
const content = match[1];

// Helper to escape Dart strings - escape \, $, and '
function escapeDart(str) {
  if (!str) return '';
  return str
    .replace(/\\/g, '\\\\')     // Escape backslashes first
    .replace(/\$/g, '\\$')      // Escape dollar signs for Dart string interpolation
    .replace(/'/g, "\\'")       // Escape single quotes
    .replace(/\n/g, ' ')        // Replace newlines with spaces
    .replace(/\r/g, '');        // Remove carriage returns
}

// Extract all word entries
const wordPattern = /"([^"]+)":\s*\{[\s\S]*?"theTake":\s*"([^"]*)"[\s\S]*?"howToUse":\s*"([^"]*)"[\s\S]*?"story":\s*"([^"]*)"[\s\S]*?"whyItExists":\s*"([^"]*)"[\s\S]*?"useAvoid":\s*"([^"]*)"[\s\S]*?"conversationPerspective":\s*\{[\s\S]*?"question":\s*"([^"]*)"[\s\S]*?"answer":\s*"([^"]*)"[\s\S]*?\}[\s\S]*?"phase_name":\s*"([^"]*)"[\s\S]*?"chapter_name":\s*"([^"]*)"/g;

const words = [];
let wordMatch;

while ((wordMatch = wordPattern.exec(content)) !== null) {
  words.push({
    word: wordMatch[1],
    theTake: wordMatch[2],
    howToUse: wordMatch[3],
    story: wordMatch[4],
    whyItExists: wordMatch[5],
    useAvoid: wordMatch[6],
    conversationQ: wordMatch[7],
    conversationA: wordMatch[8],
    phaseName: wordMatch[9],
    chapterName: wordMatch[10],
  });
}

console.log(`Found ${words.length} words`);

// Generate Dart code
let dartCode = `// AUTO-GENERATED FILE - DO NOT EDIT
// Generated from curriculum.ts
// Contains ${words.length} technical vocabulary words

import '../models/word_model.dart';

/// Curriculum data for TechTake.
/// This data is seeded into SQLite on first launch.
final List<WordModel> curriculumData = [
`;

for (const word of words) {
  const id = 'word-' + word.word.toLowerCase().replace(/[^a-z0-9]/g, '-').replace(/-+/g, '-');
  dartCode += `  WordModel(
    id: '${escapeDart(id)}',
    word: '${escapeDart(word.word)}',
    theTake: '${escapeDart(word.theTake)}',
    howToUse: '${escapeDart(word.howToUse)}',
    story: '${escapeDart(word.story)}',
    whyItExists: '${escapeDart(word.whyItExists)}',
    useAvoid: '${escapeDart(word.useAvoid)}',
    category: '${escapeDart(word.phaseName)}',
    conceptId: '${escapeDart(word.chapterName)}',
    conversationQ: '${escapeDart(word.conversationQ)}',
    conversationA: '${escapeDart(word.conversationA)}',
  ),
`;
}

dartCode += `];
`;

// Write the Dart file
const outputPath = path.join(__dirname, 'lib', 'data', 'datasources', 'curriculum_data.dart');
fs.writeFileSync(outputPath, dartCode);
console.log(`Generated ${outputPath}`);
