// SPDX-License-Identifier: CC0-1.0
pragma solidity 0.8.21;

/// @title Account-bound tokens
/// @dev See https://eips.ethereum.org/EIPS/eip-4973
/// Note: the ERC-165 identifier for this interface is 0xeb72bb7c
interface IERC4973 {
    /// @notice Count all ABTs assigned to an owner
    /// @dev ABTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param owner An address for whom to query the balance
    /// @return The number of ABTs owned by `address owner`, possibly zero
    function balanceOf(address owner) external view returns (uint256);

    /// @notice Find the address bound to an ERC4973 account-bound token
    /// @dev ABTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param tokenId The identifier for an ABT.
    /// @return The address of the owner bound to the ABT.
    function ownerOf(uint256 tokenId) external view returns (address);

    /// @notice Removes the `uint256 tokenId` from an account. At any time, an
    ///  ABT receiver must be able to disassociate themselves from an ABT
    ///  publicly through calling this function. After successfully executing this
    ///  function, given the parameters for calling `function give` or
    ///  `function take` a token must be re-equipable.
    /// @dev Must emit a `event Transfer` with the `address to` field pointing to
    ///  the zero address.
    /// @param tokenId The identifier for an ABT.
    function unequip(uint256 tokenId) external;

    /// @notice Creates and transfers the ownership of an ABT from the
    ///  transaction's `msg.sender` to `address to`.
    /// @dev Throws unless `bytes signature` represents a signature of the
    //   EIP-712 structured data hash
    ///  `Agreement(address active,address passive,bytes metadata)` expressing
    ///  `address to`'s explicit agreement to be publicly associated with
    ///  `msg.sender` and `bytes metadata`. A unique `uint256 tokenId` must be
    ///  generated by type-casting the `bytes32` EIP-712 structured data hash to a
    ///  `uint256`. If `bytes signature` is empty or `address to` is a contract,
    ///  an EIP-1271-compatible call to `function isValidSignatureNow(...)` must
    ///  be made to `address to`. A successful execution must result in the
    ///  `event Transfer(msg.sender, to, tokenId)`. Once an ABT exists as an
    ///  `uint256 tokenId` in the contract, `function give(...)` must throw.
    /// @param to The receiver of the ABT.
    /// @param metadata The metadata that will be associated to the ABT.
    /// @param signature A signature of the EIP-712 structured data hash
    ///  `Agreement(address active,address passive,bytes metadata)` signed by
    ///  `address to`.
    /// @return A unique `uint256 tokenId` generated by type-casting the `bytes32`
    ///  EIP-712 structured data hash to a `uint256`.
    function give(
        address to,
        bytes calldata metadata,
        bytes calldata signature
    ) external returns (uint256);

    /// @notice Creates and transfers the ownership of an ABT from an
    /// `address from` to the transaction's `msg.sender`.
    /// @dev Throws unless `bytes signature` represents a signature of the
    ///  EIP-712 structured data hash
    ///  `Agreement(address active,address passive,bytes metadata)` expressing
    ///  `address from`'s explicit agreement to be publicly associated with
    ///  `msg.sender` and `bytes metadata`. A unique `uint256 tokenId` must be
    ///  generated by type-casting the `bytes32` EIP-712 structured data hash to a
    ///  `uint256`. If `bytes signature` is empty or `address from` is a contract,
    ///  an EIP-1271-compatible call to `function isValidSignatureNow(...)` must
    ///  be made to `address from`. A successful execution must result in the
    ///  emission of an `event Transfer(from, msg.sender, tokenId)`. Once an ABT
    ///  exists as an `uint256 tokenId` in the contract, `function take(...)` must
    ///  throw.
    /// @param from The origin of the ABT.
    /// @param metadata The metadata that will be associated to the ABT.
    /// @param signature A signature of the EIP-712 structured data hash
    ///  `Agreement(address active,address passive,bytes metadata)` signed by
    ///  `address from`.

    /// @return A unique `uint256 tokenId` generated by type-casting the `bytes32`
    ///  EIP-712 structured data hash to a `uint256`.
    function take(
        address from,
        bytes calldata metadata,
        bytes calldata signature
    ) external returns (uint256);

    /// @notice Decodes the opaque metadata bytestring of an ABT into the token
    ///  URI that will be associated with it once it is created on chain.
    /// @param metadata The metadata that will be associated to an ABT.
    /// @return A URI that represents the metadata.
    function decodeURI(
        bytes calldata metadata
    ) external returns (string memory);
}
