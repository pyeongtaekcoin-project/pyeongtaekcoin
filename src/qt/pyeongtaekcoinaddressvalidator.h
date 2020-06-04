// Copyright (c) 2011-2014 The Pyeongtaekcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef PYEONGTAEKCOIN_QT_PYEONGTAEKCOINADDRESSVALIDATOR_H
#define PYEONGTAEKCOIN_QT_PYEONGTAEKCOINADDRESSVALIDATOR_H

#include <QValidator>

/** Base58 entry widget validator, checks for valid characters and
 * removes some whitespace.
 */
class PyeongtaekcoinAddressEntryValidator : public QValidator
{
    Q_OBJECT

public:
    explicit PyeongtaekcoinAddressEntryValidator(QObject *parent);

    State validate(QString &input, int &pos) const;
};

/** Pyeongtaekcoin address widget validator, checks for a valid pyeongtaekcoin address.
 */
class PyeongtaekcoinAddressCheckValidator : public QValidator
{
    Q_OBJECT

public:
    explicit PyeongtaekcoinAddressCheckValidator(QObject *parent);

    State validate(QString &input, int &pos) const;
};

#endif // PYEONGTAEKCOIN_QT_PYEONGTAEKCOINADDRESSVALIDATOR_H
